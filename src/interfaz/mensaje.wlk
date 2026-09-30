import wollok.game.*
import objetosEnJuego.objetosEnJuego.*
import eventos.*

object mensaje inherits ObjetoEnJuego {
	override method image() = "assets/Interfaz/Mensaje/Cuadro.png"
	
	method posicion() = game.at(16, game.height() - 2)
	
	method position() = self.posicion()
	
	method mostrarInformacionDe(_objetoConInformacion) {
		self.ocultar()
		game.addVisual(self)
		game.addVisual(mensajeTexto)
		mensajeTexto.establecerTexto(_objetoConInformacion)
	}
	
	method mostrarInformacionDe(_objetoConInformacion, tiempo) {
		self.mostrarInformacionDe(_objetoConInformacion)
		new EventoSimple(
			lista = eventos1Segundo,
			demora = tiempo,
			accion = { self.ocultar() }
		).comenzar()
	}
	
	method ocultar() {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
			game.removeVisual(mensajeTexto)
		}
	}
}

object mensajeTexto inherits ObjetoEnJuego {
	var objetoConTexto = null
	
	method position() = mensaje.posicion()
	
	override method image() = ("assets/Interfaz/Mensaje/" + objetoConTexto.informacion()) + ".png"
	
	method establecerTexto(_objetoConTexto) {
		objetoConTexto = _objetoConTexto
	}
}

object tutorial {
	var indice = 1
	const eventoTutorial = new EventoPeriodico(
		lista = eventos1Segundo,
		periodo = 12,
		accion = { self.avanzarTutorial() }
	)
	
	method informacion() = "Tutorial/Tutorial_" + indice
	
	method iniciar() {
		mensaje.mostrarInformacionDe(self, 12 * 9)
		eventoTutorial.comenzar()
	}
	
	method avanzarTutorial() {
		if (indice < 9) {
			indice += 1
		} else {
			eventoTutorial.interrumpir()
		}
	}
}