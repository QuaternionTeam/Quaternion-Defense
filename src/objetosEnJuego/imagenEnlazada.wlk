import wollok.game.*
import objetosEnJuego.*
import eventos.*

class ImagenEnlazada inherits ObjetoEnJuego {
	var property objetoEnlazado = null
	var property image = ""
	
	override method interactuarCon(objeto) {
		objetoEnlazado.interactuarCon(objeto)
	}
	
	override method quemar(quemador, gravedad) {
		objetoEnlazado.quemar(quemador, gravedad)
	}
	
	override method desangrar(gravedad) {
		objetoEnlazado.desangrar(gravedad)
	}
	
	override method escarchar(gravedad) {
		objetoEnlazado.escarchar(gravedad)
	}
	
	override method congelar(gravedad) {
		objetoEnlazado.congelar(gravedad)
	}
	
	override method cegar(gravedad) {
		objetoEnlazado.cegar(gravedad)
	}
	
	override method sufrirDanio(danio, agresor) {
		objetoEnlazado.sufrirDanio(danio, agresor)
	}
	
	override method recibirAtaqueDeHabilidad(danio, agresor) {
		objetoEnlazado.recibirAtaqueDeHabilidad(danio, agresor)
	}
	
	method position() = self.objetoEnlazado().position()
	
	override method image() = image
}

class AnimacionEnlazada inherits ImagenEnlazada {
	const property periodo
	const property momentoMaximo
	const property direccionImagen
	var property momentoDeAnimacion = 0
	const property animacion = new EventoPeriodico(
		lista = eventos02Segundos,
		periodo = periodo,
		accion = { self.avanzarAnimacion() }
	)
	
	method avanzarAnimacion() {
		momentoDeAnimacion += 1
		
		if (momentoDeAnimacion == momentoMaximo) {
			momentoDeAnimacion = 0
		}
	}
	
	method comenzar() {
		game.addVisual(self)
		animacion.comenzar()
	}
	
	method interrumpir() {
		animacion.interrumpir()
		game.removeVisual(self)
	}
	
	override method position() = objetoEnlazado.position()
	
	override method image() = ((direccionImagen + "/") + momentoDeAnimacion.toString()) + ".png"
}

class ParpadeoRojo inherits ImagenEnlazada {
	override method image() = "assets/Efectos/Rojo_Transparente.png"
}

class ExplosionPerforante inherits ImagenEnlazada {
	override method image() = "assets/Efectos/Explosion_Perforante.png"
}

class BarraDeVida inherits ImagenEnlazada {
	const property ocultarBarraLlena = false
	// Calcula el porcentaje de vida y lo convierte en un múltiplo de 10 (ej 97 -> 100 ; 62 -> 70)
	
	method porcentajeDeVidaRedondeado() = (objetoEnlazado.vidaActual() / objetoEnlazado.vidaMaxima()).truncate(
		1
	) * 100
	
	method estaLlena() = self.porcentajeDeVidaRedondeado() == 100
	
	method sufijo() = if (ocultarBarraLlena and self.estaLlena()) "Oculta"
	                  else self.porcentajeDeVidaRedondeado().toString()
	
	override method image() = ("assets/Interfaz/BarraDeVida/Barra_De_Vida_" + self.sufijo()) + ".png"
}

class BarraDeProgreso inherits ImagenEnlazada {
	// Calcula el porcentaje de vida y lo convierte en un múltiplo de 10 (ej 97 -> 100 ; 62 -> 70)
	method porcentajeDeProgresoRedondeado() = (objetoEnlazado.progreso() / objetoEnlazado.total()).truncate(
		1
	) * 100
	
	override method image() = ("assets/Interfaz/BarraDeInteraccion/Barra_De_Interaccion_" + self.porcentajeDeProgresoRedondeado().toString()) + ".png"
}