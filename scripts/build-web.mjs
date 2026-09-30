// @ts-check
/**
 * Builds a fully static, server-less version of Quaternion Defense.
 *
 * The regular `start` script relies on wollok-ts-cli, which runs the Wollok
 * interpreter on a Node server and streams the game state to the browser over
 * socket.io. That approach needs a running server.
 *
 * This script instead produces a static site that runs the whole game in the
 * browser using `wollok-web-tools`' `LocalGame`, which embeds the Wollok
 * interpreter (compiled to JS) client-side. The output in `dist/` can be
 * served by any static file host (GitHub Pages, Netlify, `python -m http.server`,
 * `npx serve dist`, etc.).
 *
 * What it does:
 *   1. Collects every `.wlk` / `.wpgm` source under `src/`.
 *   2. Enumerates every image / sound asset under the resource folder.
 *   3. Copies sources + assets + the prebuilt wollok-web-tools browser bundle
 *      into `dist/`.
 *   4. Emits a `manifest.json` describing the game and a small loader that
 *      boots `LocalGame`.
 */

import { fileURLToPath } from 'node:url'
import { dirname, join, relative, extname, posix, sep } from 'node:path'
import {
  cpSync,
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  rmSync,
  statSync,
  writeFileSync,
} from 'node:fs'

const __dirname = dirname(fileURLToPath(import.meta.url))
const projectRoot = join(__dirname, '..')
const srcDir = join(projectRoot, 'src')
const distDir = join(projectRoot, 'dist')

// ── Config ──────────────────────────────────────────────────────────────────

// Fully qualified name of the program's package. LocalGame's `getProgramIn`
// resolves the single `program` declared inside this package. `juego.wpgm`
// lives at the src root, so its package FQN is simply `juego`.
const PROGRAM_FQN = 'juego'

// Resource folder as declared in package.json (`resourceFolder`).
const rootPkg = JSON.parse(readFileSync(join(projectRoot, 'package.json'), 'utf8'))
const assetsFolderName = rootPkg.resourceFolder ?? 'assets'
const assetsDir = join(projectRoot, assetsFolderName)

const WOLLOK_EXTENSIONS = ['.wlk', '.wpgm']
const IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.gif']
const SOUND_EXTENSIONS = ['.mp3', '.ogg', '.wav']

// ── Helpers ─────────────────────────────────────────────────────────────────

/** Recursively list files under `dir`, returning absolute paths. */
function walk(dir) {
  /** @type {string[]} */
  const out = []
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name)
    if (entry.isDirectory()) out.push(...walk(full))
    else out.push(full)
  }
  return out
}

/** Turn an OS path relative to a base into a forward-slash relative path. */
function toPosixRelative(base, full) {
  return relative(base, full).split(sep).join(posix.sep)
}

// ── Templates ─────────────────────────────────────────────────────────────

const INDEX_HTML = `<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quaternion Defense</title>
    <script>
      // wollok-web-tools' bundle expects a Node-like \`process\` global.
      var process = { env: {} };
    </script>
    <script src="./lib/game-index.js"></script>
    <style>
      html, body {
        margin: 0;
        height: 100%;
        background: #111;
        color: #eee;
        font-family: system-ui, sans-serif;
        overflow: hidden;
      }
      main {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100vh;
      }
      .p5Canvas { margin: auto; image-rendering: pixelated; }
      #loading {
        position: fixed;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        gap: 1rem;
        font-size: 1.25rem;
      }
      #loading.hidden { display: none; }
      #error {
        max-width: 90vw;
        white-space: pre-wrap;
        color: #ff6b6b;
        font-family: monospace;
      }
    </style>
  </head>
  <body>
    <div id="loading">
      <div>Cargando Quaternion Defense…</div>
      <div id="error"></div>
    </div>
    <main>
      <div id="game"></div>
    </main>
    <script src="./loader.js"></script>
  </body>
</html>
`

const LOADER_JS = `// Boots the game entirely client-side using wollok-web-tools' LocalGame.
(async function () {
  const loading = document.getElementById('loading')
  const errorBox = document.getElementById('error')
  const parent = document.getElementById('game')

  function fail(message) {
    if (errorBox) errorBox.textContent = String(message)
    // eslint-disable-next-line no-console
    console.error(message)
  }

  try {
    const manifest = await fetch('./manifest.json').then(function (r) {
      if (!r.ok) throw new Error('No se pudo cargar manifest.json (' + r.status + ')')
      return r.json()
    })

    if (typeof window.LocalGame !== 'function') {
      throw new Error('LocalGame no está disponible. ¿Se cargó lib/game-index.js?')
    }

    const project = {
      main: manifest.main,
      sources: manifest.sources,
      description: manifest.description,
      images: manifest.images,
      sounds: manifest.sounds,
    }

    const game = new window.LocalGame(project)
    game.start(parent)

    if (loading) loading.classList.add('hidden')
  } catch (err) {
    if (loading) loading.classList.remove('hidden')
    fail((err && err.stack) || err)
  }
})()
`

// ── Build ───────────────────────────────────────────────────────────────────

console.log('🧹 Cleaning dist/ ...')
rmSync(distDir, { recursive: true, force: true })
mkdirSync(distDir, { recursive: true })

// 1. Collect Wollok sources -------------------------------------------------
console.log('📜 Collecting Wollok sources ...')
const sourceFiles = walk(srcDir).filter(f =>
  WOLLOK_EXTENSIONS.includes(extname(f).toLowerCase()),
)

const sources = sourceFiles.map(full => ({
  name: toPosixRelative(srcDir, full),
  content: readFileSync(full, 'utf8'),
}))
console.log(`   ${sources.length} source files`)

// 2. Collect assets ---------------------------------------------------------
console.log('🖼️  Collecting assets ...')
if (!existsSync(assetsDir)) {
  throw new Error(`Assets folder not found: ${assetsDir}`)
}
const assetFiles = walk(assetsDir)

/** @type {{ possiblePaths: string[], url: string }[]} */
const images = []
/** @type {{ possiblePaths: string[], url: string }[]} */
const sounds = []

for (const full of assetFiles) {
  const ext = extname(full).toLowerCase()
  const relPosix = toPosixRelative(assetsDir, full) // e.g. Interfaz/Cursores/x.png
  const url = `${assetsFolderName}/${relPosix}`

  if (IMAGE_EXTENSIONS.includes(ext)) {
    // The game references images by their path relative to the assets root
    // (e.g. "Interfaz/Cursores/Cursor.png").
    images.push({ possiblePaths: [relPosix], url })
  } else if (SOUND_EXTENSIONS.includes(ext)) {
    // Sounds are referenced by file name only (e.g. "Cursor.wav"), and also
    // support the full relative path just in case.
    const baseName = relPosix.split(posix.sep).pop()
    const paths =
      baseName && baseName !== relPosix ? [baseName, relPosix] : [relPosix]
    sounds.push({ possiblePaths: paths, url })
  }
}
console.log(`   ${images.length} images, ${sounds.length} sounds`)

// 3. Copy assets into dist --------------------------------------------------
console.log('📦 Copying assets ...')
cpSync(assetsDir, join(distDir, assetsFolderName), { recursive: true })

// 4. Copy the prebuilt wollok-web-tools browser bundle ----------------------
console.log('🌐 Copying wollok-web-tools browser bundle ...')
const bundleSrc = join(
  projectRoot,
  'node_modules',
  'wollok-web-tools',
  'dist',
  'web',
  'game-index.js',
)
if (!existsSync(bundleSrc)) {
  throw new Error(
    `Could not find wollok-web-tools browser bundle at ${bundleSrc}. ` +
      'Did you run `pnpm install`?',
  )
}
const libDir = join(distDir, 'lib')
mkdirSync(libDir, { recursive: true })
cpSync(bundleSrc, join(libDir, 'game-index.js'))

// 5. Emit the manifest ------------------------------------------------------
console.log('🧾 Writing manifest.json ...')
const manifest = {
  main: PROGRAM_FQN,
  sources,
  images,
  sounds,
  description: '## Quaternion Defense',
}
writeFileSync(join(distDir, 'manifest.json'), JSON.stringify(manifest))

// 6. Emit loader + html -----------------------------------------------------
console.log('📝 Writing loader and index.html ...')
writeFileSync(join(distDir, 'loader.js'), LOADER_JS)
writeFileSync(join(distDir, 'index.html'), INDEX_HTML)

const bytes = statSync(join(distDir, 'manifest.json')).size
console.log('\n✅ Static build ready in dist/')
console.log(`   manifest.json: ${(bytes / 1024).toFixed(1)} KiB`)
console.log('\nServe it with any static server, e.g.:')
console.log('   pnpm run serve')
console.log('   or:  npx serve dist')
