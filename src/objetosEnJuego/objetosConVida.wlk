import wollok.game.*
import objetosEnJuego.*
import escenario.*
import imagenEnlazada.*
import eventos.*

class ObjetoConVida inherits ObjetoEnJuego {
	const property barraDeVida = new BarraDeVida(
		objetoEnlazado = self,
		ocultarBarraLlena = self.ocultarBarraLlena()
	)
	var vidaMaxima = self.vidaMaximaInicial()
	var multiplicadorDeVidaMaxima = 100
	var vidaActual = self.vidaActualInicial()
	var comportamientoCuracion = curacionHabilitada
	
	/******************** Salud ********************/
	method vidaActual() = vidaActual
	
	method vidaMaxima() = vidaMaxima * self.multiplicadorDeVidaMaxima()
	
	method vidaMaximaInicial() = 100
	
	method vidaActualInicial() = self.vidaMaxima()
	
	method ocultarBarraLlena() = false
	
	method multiplicadorDeVidaMaxima() = multiplicadorDeVidaMaxima / 100
	
	method modificarVidaMaxima(modificacion) {
		vidaMaxima += modificacion
		vidaActual = self.vidaMaxima().min(vidaActual).roundUp()
	}
	
	method modificarVidaActual(modificacion) {
		vidaActual = 0.max(self.vidaMaxima().min(vidaActual + modificacion)).roundUp()
	}
	
	method modificarMultiplicadorDeVidaMaxima(modificacion) {
		multiplicadorDeVidaMaxima += modificacion
	}
	
	method porcentajeDeVidaMaxima(
		porcentaje
	) = (self.vidaMaxima() * porcentaje) / 100
	
	method porcentajeDeVidaActual() = (vidaActual / self.vidaMaxima()) * 100
	
	method cambiarComportamientoCuracion(comportamiento) {
		comportamientoCuracion = comportamiento
	}
	
	// Aumenta los puntos de salud en la cantidad indicada sin superar la salud maxima
	method curar(cura) {
		comportamientoCuracion.curar(self, cura)
	}
	
	method habilitarCuracion() {
		comportamientoCuracion.habilitarCuracion(self)
	}
	
	method deshabilitarCuracion() {
		comportamientoCuracion.deshabilitarCuracion(self)
	}
	
	// Disminuye los puntos de salud en la cantidad indicada sin bajar de cero
	override method sufrirDanio(danio, agresor) {
		const parpadeoRojo = new ParpadeoRojo(objetoEnlazado = self)
		game.addVisual(parpadeoRojo)
		
		new EventoSimple(
			lista = eventos02Segundos,
			demora = 0.2,
			accion = { game.removeVisual(parpadeoRojo) }
		).comenzar()
		
		self.modificarVidaActual(-0.max(danio))
		if (vidaActual == 0) self.recibioDanioLetal(danio, agresor)
	}
	
	method recibioDanioLetal(danio, agresor)
	
	method agregarVisuales() {
		game.addVisual(self)
		game.addVisual(barraDeVida)
	}
	
	method removerVisuales() {
		game.removeVisual(self)
		game.removeVisual(barraDeVida)
	}
	
	method inicializar() {
		vidaActual = self.vidaMaxima()
		self.agregarVisuales()
	}
}

object curacionHabilitada {
	method curar(objetoConVida, vida) {
		objetoConVida.modificarVidaActual(vida)
	}
	
	method habilitarCuracion(objetoConVida) {
		
	}
	
	method deshabilitarCuracion(objetoConVida) {
		objetoConVida.cambiarComportamientoCuracion(curacionDeshabilitada)
	}
}

object curacionDeshabilitada {
	method curar(objetoConVida, vida) {
		
	}
	
	method habilitarCuracion(objetoConVida) {
		objetoConVida.cambiarComportamientoCuracion(curacionHabilitada)
	}
	
	method deshabilitarCuracion(objetoConVida) {
		
	}
}