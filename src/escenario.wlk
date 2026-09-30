import wollok.game.*
import pantalla.*
import menues.menuDePreparacion.*
import interfaz.inventarioGeneral.*
import interfaz.inventarioDeRecursos.*
import interfaz.interfaz.*
import interfaz.cursores.*
import interfaz.mensaje.*
import personajes.enemigos.*
import items.materiales.*
import items.equipos.*
import objetosEnJuego.objetosExtraibles.*
import objetosEnJuego.objetosDeInteraccion.*
import objetosEnJuego.fondos.*
import objetosEnJuego.drops.*
import sonidos.*
import probabilidad.*
import reloj.*
import eventos.*

object escenario {
	const anchoEscenario = pantalla.ancho() - 3
	const altoEscenario = pantalla.alto() - 2
	var indiceSobrevivienteSeleccionado = 0
	const property sobrevivientes = []
	const property enemigos = []
	const property estructuras = []
	//var musica = new SonidoEnBucle("Musica1.wav", 7500)
	var nivel = 1
	var nroHorda = 1
	const eventoHordas = new EventoPeriodico(
		lista = eventos1Segundo,
		periodo = 35,
		accion = { self.avanzarHorda() }
	)
	
	method nivel() = nivel
	
	method nroHorda() = nroHorda
	
	/******************** SpawnPoints ********************/
	method spawnPoints(posX) = (1 .. (pantalla.alto() - 3)).map(
		{ posY => game.at(posX, posY) }
	)
	
	method spawnPointsValidos(posX) = self.spawnPoints(posX).filter(
		{ posicion => self.esAtravesable(posicion) }
	)
	
	method spawnPointsValido(posX) = self.spawnPointsValidos(posX).anyOne()
	
	/******************** Sobrevivientes ********************/
	method haySobrevivientes() = not sobrevivientes.isEmpty()
	
	method agregarSobreviviente(sobreviviente) {
		sobrevivientes.add(sobreviviente)
	}
	
	method spawnearSobreviviente(sobreviviente) {
		sobreviviente.inicializar(self.spawnPointsValido(1))
		self.agregarSobreviviente(sobreviviente)
	}
	
	// Agrega los personajes de la lista de personajes al escenario
	method spawnearSobrevivientes(sobrevivientesAAgregar) {
		sobrevivientesAAgregar.forEach(
			{ sobreviviente => self.spawnearSobreviviente(sobreviviente) }
		)
		cursorSobrevivienteSeleccionado.agregar()
	}
	
	method sobrevivienteSeleccionado() = sobrevivientes.get(
		indiceSobrevivienteSeleccionado
	)
	
	method alternarSobreviviente() {
		indiceSobrevivienteSeleccionado += 1
		if (indiceSobrevivienteSeleccionado >= sobrevivientes.size()) {
			indiceSobrevivienteSeleccionado = 0
		}
	}
	
	method esSobrevivienteSeleccionado(
		sobreviviente
	) = sobreviviente == self.sobrevivienteSeleccionado()
	
	// Verifica si el sorbeviente esta antes en las lista de sobrevivientes que el sobreviviente seleccionado
	method estaAntesQueElSobrevivienteSeleccionado(
		sobreviviente
	) = sobrevivientes.filter(
		{ _sobreviviente =>
			(_sobreviviente == sobreviviente) or self.esSobrevivienteSeleccionado(
				_sobreviviente
			) }
	).head() == sobreviviente
	
	method esElUltimoSobrevivienteEnLaLista(
		sobreviviente
	) = sobrevivientes.last() == sobreviviente
	
	method removerSobreviviente(sobreviviente) {
		if (self.esSobrevivienteSeleccionado(sobreviviente)) {
			if (self.esElUltimoSobrevivienteEnLaLista(sobreviviente)) {
				indiceSobrevivienteSeleccionado = 0
			}
			// Se alterna el sobrecviviente seleccionado al primero solo si era el ultimo
			sobrevivientes.remove(sobreviviente)
			
			
			
			
			
			
			
			
			
			
			
			
			// Saca al sobreviviente de la lista de sobrevivientes
			if (not self.haySobrevivientes()) // Si no hay sobrevivientes en juego
				self.perder()
		} else {
			if (self.estaAntesQueElSobrevivienteSeleccionado(sobreviviente)) {
				// 1. NO: 3. Eobreviviente esta antes en la lista que el sobreviviente seleccionado?:
				indiceSobrevivienteSeleccionado -= 1
			}
			// 3. SI: Disminuye el indice de la lista
			sobrevivientes.remove(sobreviviente)
		}
	}
	
	/******************** Enemigos ********************/
	method agregarEnemigo(enemigo) {
		enemigos.add(enemigo)
	}
	
	method spawnearEnemigo(enemigo) {
		try // Los zombies producen una excepción al ser creados si no encuentran lugar disponible para spawnear
		{
			enemigo.inicializar(self.spawnPointsValido(pantalla.ancho() - 3))
			self.agregarEnemigo(enemigo)
		} catch e : Exception {
			console.println("No había spawn point válido para crear enemigo!")
		}
	}
	
	method removerEnemigo(enemigo) {
		enemigos.remove(enemigo)
		if (enemigos.isEmpty() and self.esUltimaHorda()) self.ganar()
	}
	
	/******************** Generacion de Escenario ********************/
	// Coloca fondo en cada posicion del escenario 
	method colocarFondos(tipoDeFondo) {
		anchoEscenario.times(
			{ x => altoEscenario.times(
					{ y => new FondoEscenario(
							suelo = tipoDeFondo,
							posX = (anchoEscenario - x) + 1,
							posY = y
						).ubicar() }
				) }
		)
		anchoEscenario.times(
			{ x => new FondoBordeConSuelo(suelo = tipoDeFondo).ubicar(
					(anchoEscenario - x) + 1,
					0
				) }
		)
		altoEscenario.times(
			{ y => new FondoBordeConSuelo(suelo = tipoDeFondo).ubicar(0, y) }
		)
	}
	
	// Genera el escenario y la interfaz
	method generar() {
		if ((nivel % 3) == 0) {
			self.generarEscenarioDesierto()
		} else {
			if ((nivel % 2) == 0) self.generarEscenarioNieve()
			else self.generarEscenarioPasto()
		}
		
		// Interfaz: genera la interfaz del escenario
		interfaz.generar()
	}
	
	method generarEscenarioPasto() {
		self.colocarFondos(pasto) // Coloca pasto
		
		2.times({ i => self.crearLago() }) // Genera lagos al azar
		
		// Genera recursos
		8.times(
			{ i => new ArbustoVerde().ubicarEn(self.posicionAleatoriaDisponible()) }
		)
		
		8.times({ i => new Roca().ubicarEn(self.posicionAleatoriaDisponible()) })
		8.times(
			{ i => new MinaDeHierro().ubicarEn(self.posicionAleatoriaDisponible()) }
		)
		3.times({ i => new MinaDeOro().ubicarEn(self.posicionAleatoriaDisponible()) })
		
		
		20.times(
			{ i => self.crearBosque({ numero => new ArbolVerde(numero = numero) }, 6) }
		)
		20.times(
			{ i => self.crearBosque(
					{ numero => new ArbolVerdeOscuro(numero = numero) },
					6
				) }
		)
		10.times(
			{ i => self.crearBosque({ numero => new ArbolNaranja(numero = numero) }, 6) }
		)
	}
	
	method generarEscenarioNieve() {
		self.colocarFondos(nieve) // Coloca nieve
		2.times({ i => self.crearLago() }) // Genera lagos al azar
		
		// Genera recursos			
		8.times(
			{ i => new ArbustoNevado().ubicarEn(self.posicionAleatoriaDisponible()) }
		)
		
		8.times({ i => new Roca().ubicarEn(self.posicionAleatoriaDisponible()) })
		8.times(
			{ i => new MinaDeHierro().ubicarEn(self.posicionAleatoriaDisponible()) }
		)
		3.times({ i => new MinaDeOro().ubicarEn(self.posicionAleatoriaDisponible()) })
		
		60.times(
			{ i => self.crearBosque({ numero => new ArbolNevado(numero = numero) }, 6) }
		)
	}
	
	method generarEscenarioDesierto() {
		self.colocarFondos(arena) // Coloca arena
		
		// Genera recursos
		15.times({ i => new Roca().ubicarEn(self.posicionAleatoriaDisponible()) })
		8.times(
			{ i => new MinaDeHierro().ubicarEn(self.posicionAleatoriaDisponible()) }
		)
		3.times({ i => new MinaDeOro().ubicarEn(self.posicionAleatoriaDisponible()) })
		
		30.times(
			{ i => self.crearBosque({ numero => new ArbolPelado(numero = numero) }, 2) }
		)
	}
	
	method iniciar(sobrevivientesIniciales) {
		self.generar()
		self.spawnearSobrevivientes(sobrevivientesIniciales)
		eventoHordas.comenzar()
		
		
		
		
		
		
		
		
		
		
		
		
		
		//musica.reproducir()
		if (nivel == 1) tutorial.iniciar()
	}
	
	/******************** Posiciones ********************/
	method posicionAleatoria() = game.at(
		1.randomUpTo(anchoEscenario).truncate(0),
		1.randomUpTo(altoEscenario).truncate(0)
	)
	
	method posicionAleatoriaDisponible() {
		const posicionAleatoria = self.posicionAleatoria()
		if ((game.getObjectsIn(posicionAleatoria).size() == 1) and self.esAtravesable(
			posicionAleatoria
		)) {
			return posicionAleatoria
		} else {
			return self.posicionAleatoriaDisponible()
		}
	}
	
	// Verdadero si puede estar en esa posicion, Falso si no
	method esAtravesable(posicion) = self.estaDentro(
		posicion
	) and game.getObjectsIn(posicion).all({ objeto => objeto.esAtravesable() })
	
	method estaDentro(posicion) = posicion.x().between(
		1,
		anchoEscenario
	) and posicion.y().between(1, altoEscenario)
	
	method fondo(posicion) {
		const elementos = game.at(posicion.x(), posicion.y()).allElements()
		if (elementos.size() >= 1) {
			return elementos.head()
		} else {
			return fondoFueraDelMapa
		}
	}
	
	method crearBosque(creadorDeArboles, variaciones) {
		const posicion = self.posicionAleatoriaDisponible()
		const cantidadDeArboles = 1.randomUpTo(variaciones)
		const arbolesDisponibles = (1 .. variaciones).map({ n => n })
		
		cantidadDeArboles.times(
			{ i =>
				const numeroArbol = arbolesDisponibles.anyOne()
				arbolesDisponibles.remove(numeroArbol)
				return creadorDeArboles.apply(numeroArbol).ubicarEn(posicion)
			}
		)
	}
	
	method crearLago() {
		const centro = self.posicionAleatoria()
		self.fondo(centro).convertirEn(agua)
		
		const adyacentes = #{
			centro.up(1),
			centro.down(1),
			centro.left(1),
			centro.right(1)
		}
		adyacentes.forEach(
			{ posicion => if (self.esAtravesable(posicion) && probabilidad.en100De(40))
				             	self.fondo(posicion).convertirEn(agua) }
		)
	}
	
	/******************** Nivel ********************/
	method hordasDelNivel() = 5 + (nivel * 5)
	
	method esUltimaHorda() = nroHorda == self.hordasDelNivel()
	
	method avanzarHorda() {
		if (not self.esUltimaHorda()) self.generarHorda()
		else eventoHordas.interrumpir()
	}
	
	method generarHorda() {
		(nroHorda / 5).roundUp().times(
			{ n => if (probabilidad.en100De(((nroHorda - 12) + (nivel * 2)) * 3)) {
					self.spawnearEnemigo(new ZombieTanque())
				} else {
					if (probabilidad.en100De(((nroHorda - 7) + (nivel * 2)) * 3)) {
						self.spawnearEnemigo(new ZombieGordo())
					} else {
						if (probabilidad.en100De(((nroHorda - 4) + nivel) * 3))
							self.spawnearEnemigo(new ZombieTipo2())
						else self.spawnearEnemigo(new ZombieTipo1())
					}
				} }
		)
		nroHorda += 1
	}
	
	method ganar() {
		new EventoSimple(
			lista = eventos02Segundos,
			demora = 0.7,
			accion = { sobrevivientes.forEach(
					{ sobreviviente => game.say(sobreviviente, "Ganamos!") }
				) }
		).comenzar()
		puntos.agregar(2 + (nivel * 2))
		nivel += 1
		new EventoSimple(
			lista = eventos1Segundo,
			demora = 1,
			accion = { self.terminar() }
		).comenzar()
	}
	
	method perder() {
		new EventoSimple(
			lista = eventos02Segundos,
			demora = 0.7,
			accion = { enemigos.forEach(
					{ enemigo => game.say(enemigo, "Perdiste! JAJAJA") }
				) }
		).comenzar()
		new EventoSimple(
			lista = eventos1Segundo,
			demora = 1,
			accion = { self.terminar() }
		).comenzar()
	}
	
	method terminar() {
		//musica.terminar()
		sobrevivientes.forEach({ sobreviviente => sobreviviente.reiniciar() })
		sobrevivientes.clear()
		enemigos.clear()
		estructuras.clear()
		
		inventarioGeneral.limpiar()
		inventarioDeRecursos.reiniciarRecursos()
		
		game.allVisuals().forEach({ visual => game.removeVisual(visual) })
		menuDePreparacion.generar()
	}
	
	method numeroAMostrar() = nivel
}