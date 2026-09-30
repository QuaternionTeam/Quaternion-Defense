import wollok.game.*
import objetosEnJuego.*
import elementos.*
import sonidos.*
import probabilidad.*

class FondoEscenario inherits ObjetoEnJuego {
	const property posX
	const property posY
	const property posicion = game.at(posX, posY)
	var property suelo
	var property estadoDrop = noTieneDrop
	var property drop = null
	
	method agregarDrop(_drop) {
		drop = _drop
		estadoDrop = tieneDrop
	}
	
	method removerDrop() {
		drop = null
		estadoDrop = noTieneDrop
	}
	
	method drop() = drop
	
	method pisar(pisador) {
		estadoDrop.agarrarDrop(self, pisador)
	}
	
	method convertirEn(nuevoSuelo) {
		suelo = nuevoSuelo
	}
	
	method position() = posicion
	
	method ubicar() {
		game.addVisual(self)
	}
	
	method encenderFuego(usuario, gravedad, sonidoConjunto) {
		suelo.encenderFuego(usuario, gravedad, sonidoConjunto, posicion)
	}
	
	override method image() = suelo.image()
	
	override method esAtravesable() = suelo.esAtravesable()
}

object tieneDrop {
	method agarrarDrop(fondo, pisador) {
		pisador.agarrarDrop(fondo.drop())
	}
}

object noTieneDrop {
	method agarrarDrop(fondo, pisador) {
		
	}
}

class Suelo {
	method esAtravesable() = true
	
	method encenderFuego(usuario, gravedad, sonidoConjunto, posicion) {
		new Fuego(
			iniciador = usuario,
			gravedad = gravedad,
			sonidoConjunto = sonidoConjunto
		).activarEn(posicion)
	}
}

object tierra inherits Suelo {
	method image() = "assets/Terreno/Suelo/Transparente.png"
}

class Fuego inherits Elemento {
	const property sonidoConjunto
	const property gravedad
	
	override method efectoInicial() {
		sonidoConjunto.reproducir("Fuego.wav")
	}
	
	override method efectoPeriodico() {
		game.colliders(self).forEach({ objeto => objeto.quemar(iniciador, gravedad) })
	}
	
	override method efectoAlTerminar() {
		game.colliders(self).head().convertirEn(tierra)
	}
	
	override method nombre() = "Fuego"
}

object pasto inherits Suelo {
	method image() = "assets/Terreno/Suelo/Pasto.png"
}

object arena inherits Suelo {
	method image() = "assets/Terreno/Suelo/Arena.png"
}

object nieve inherits Suelo {
	method image() = "assets/Terreno/Suelo/Nieve.png"
}

object agua inherits Suelo {
	method image() = "assets/Terreno/Suelo/Agua.png"
	
	override method esAtravesable() = false
	
	override method encenderFuego(usuario, gravedad, sonidoConjunto, posicion) {
		
	}
}

class FondoBordeConSuelo inherits ObjetoEnJuego {
	const property suelo
	
	method convertirEn(nuevoSuelo) {
		
	}
	
	override method esAtravesable() = false
	
	method encenderFuego(usuario, gravedad, sonidoConjunto) {
		
	}
	
	override method image() = suelo.image()
	
	var property position = game.origin()
	
	method ubicar(posX, posY) {
		position = game.at(posX, posY)
		game.addVisual(self)
	}
}

class FondoInterfaz inherits ObjetoEnJuego {
	const property imagen
	const property image = ("assets/Interfaz/Marco/" + imagen) + ".png"
	var property position = game.origin()
	
	method convertirEn(nuevoSuelo) {
		
	}
	
	override method esAtravesable() = false
	
	method encenderFuego(usuario, gravedad, sonidoConjunto) {
		
	}
	
	method ubicar(posX, posY) {
		position = game.at(posX, posY)
		game.addVisual(self)
	}
}

object fondoFueraDelMapa inherits ObjetoEnJuego {
	override method image() = ""
	
	method convertirEn(nuevoSuelo) {
		
	}
	
	override method esAtravesable() = false
	
	method encenderFuego(usuario, gravedad, sonidoConjunto) {
		
	}
}