import wollok.game.*
import objetosEnJuego.*
import eventos.*

//Elemento danino (fuego, rayo, posibles futuros elementos que produzcan un efecto dañino y animacion
class Elemento inherits ObjetoEnJuego {
	const property duracion = 4
	const property iniciador
	var property position = game.origin()
	var property estado = 0
	const property eventoDeElemento = new EventoPeriodicoTemporal(
		lista = eventos02Segundos,
		duracion = duracion,
		periodo = 0.2,
		accion = { self.avanzarEfecto() },
		accionAlTerminar = { 
			self.efectoAlTerminar()
			return game.removeVisual(self)
		}
	)
	
	method nombre()
	
	method animacion() = ""
	
	method efectoInicial()
	
	method efectoPeriodico()
	
	method efectoAlTerminar()
	
	method activarEn(posicion) {
		position = posicion
		game.addVisual(self)
		estado = 0
		eventoDeElemento.comenzar()
		self.efectoInicial()
	}
	
	method avanzarEfecto() {
		estado += 1
		if (estado >= 4) {
			estado = 0
		}
		self.efectoPeriodico()
	}
	
	method apagar() {
		self.efectoAlTerminar()
		eventoDeElemento.ejecutar()
	}
	
	override method image() = (((("assets/Efectos/" + self.nombre()) + "/") + self.animacion()) + estado) + ".png"
}

class Rayo inherits Elemento {
	override method efectoInicial() {
		
	}
	
	override method efectoPeriodico() {
		game.colliders(self).forEach({ objeto => objeto.sufrirDanio(15, iniciador) })
	}
	
	override method efectoAlTerminar() {
		
	}
	
	override method nombre() = "Rayo"
	
	override method animacion() = iniciador.orientacion().toString() + "_"
}