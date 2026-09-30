import wollok.game.*
import eventos.*
import personajes.*
import objetosEnJuego.imagenEnlazada.*

/******************** Estado Alterado ********************/
class EstadoAlterado {
	const property victima
	var property gravedad
	const property efecto = self.efectoInicial()
	const property animacion = self.animacionInicial()
	
	method efectoInicial() = null
	
	method animacionInicial() = null
	
	method aumentarDuracion(aumento) {
		efecto.aumentarDemora(aumento)
	}
	
	method reiniciarDuracion() {
		efecto.reiniciar()
	}
	
	method aumentarGravedad(n) {
		gravedad += n
	}
}

class Quemadura inherits EstadoAlterado {
	const duracion = 5
	const property agresor
	
	override method animacionInicial() = new AnimacionEnlazada(
		periodo = 0.1,
		momentoMaximo = 4,
		objetoEnlazado = victima,
		direccionImagen = "EstadosAlterados/Quemadura/"
	)
	
	override method efectoInicial() = new EventoPeriodicoTemporal(
		lista = eventos1Segundo,
		duracion = duracion,
		periodo = 1,
		accion = { victima.sufrirDanio(
				victima.porcentajeDeVidaMaxima(gravedad),
				agresor
			) },
		accionAlTerminar = { self.terminar() }
	)
	
	method aplicar() {
		victima.estadoDeQuemadura().aplicar(self)
	}
	
	method comenzar() {
		victima.quemadura(self)
		victima.estadoDeQuemadura(tieneEstadoAlterado)
		
		efecto.comenzar()
		animacion.comenzar()
	}
	
	method terminar() {
		victima.quemadura(null)
		victima.estadoDeQuemadura(noTieneEstadoAlterado)
		
		efecto.interrumpir()
		animacion.interrumpir()
	}
	
	method reAplicar() {
		const quemaduraAnterior = victima.quemadura()
		
		quemaduraAnterior.terminar()
		
		const quemaduraDeMayorGravedad = [quemaduraAnterior, self].max(
			{ quemadura => quemadura.gravedad() }
		)
		
		quemaduraDeMayorGravedad.aplicar()
	}
}

class Sangrado inherits EstadoAlterado {
	const duracion = 6
	
	override method animacionInicial() = new AnimacionEnlazada(
		periodo = 0.2,
		momentoMaximo = 3,
		objetoEnlazado = victima,
		direccionImagen = "EstadosAlterados/Sangrado/"
	)
	
	override method efectoInicial() = new EventoSimple(
		lista = eventos1Segundo,
		demora = duracion,
		accion = { victima.curarSangrado() }
	)
	
	method aplicar() {
		victima.estadoDeSangrado().aplicar(self)
	}
	
	method comenzar() {
		victima.modificarConstanteDeDanioRecibido(gravedad)
		victima.sangrado(self)
		victima.estadoDeSangrado(tieneEstadoAlterado)
		
		efecto.comenzar()
		animacion.comenzar()
	}
	
	method terminar() {
		victima.modificarConstanteDeDanioRecibido(-gravedad)
		victima.sangrado(null)
		victima.estadoDeSangrado(noTieneEstadoAlterado)
		
		efecto.interrumpir()
		animacion.interrumpir()
	}
	
	method reAplicar() {
		const sangradoAnterior = victima.sangrado()
		
		sangradoAnterior.aumentarGravedad(gravedad * 2)
		sangradoAnterior.reiniciarDuracion()
	}
	
	override method aumentarGravedad(n) {
		super(n)
		victima.modificarConstanteDeDanioRecibido(n)
	}
}

class Escarcha inherits EstadoAlterado {
	const duracion = 3
	
	override method animacionInicial() = new ImagenEnlazada(
		objetoEnlazado = victima,
		image = ("EstadosAlterados/Escarcha/" + gravedad.toString()) + ".png"
	)
	
	override method efectoInicial() = new EventoSimple(
		lista = eventos1Segundo,
		demora = duracion,
		accion = { victima.curarEscarcha() }
	)
	
	method aplicar() {
		victima.estadoDeEscarcha().aplicar(self)
	}
	
	method comenzar() {
		if (victima.congelado() == null) {
			victima.modificarProbabilidadDeBloqueo((-10) * gravedad)
			victima.modificarProbabilidadDeEvasion((-10) * gravedad)
			victima.modificarAtaque((-5) * gravedad)
			
			victima.escarcha(self)
			victima.estadoDeEscarcha(tieneEstadoAlterado)
			
			efecto.comenzar()
			game.addVisual(animacion)
		}
	}
	
	method terminar() {
		victima.modificarProbabilidadDeBloqueo(10 * gravedad)
		victima.modificarProbabilidadDeEvasion(10 * gravedad)
		victima.modificarAtaque(5 * gravedad)
		
		victima.escarcha(null)
		victima.estadoDeEscarcha(noTieneEstadoAlterado)
		
		efecto.interrumpir()
		game.removeVisual(animacion)
	}
	
	method reAplicar() {
		const escarchaAnterior = victima.escarcha()
		
		escarchaAnterior.aumentarGravedad(gravedad)
		escarchaAnterior.efecto().reiniciar()
	}
	
	override method aumentarGravedad(n) {
		super(n)
		
		if (gravedad < 5) {
			victima.modificarProbabilidadDeBloqueo((-10) * n)
			victima.modificarProbabilidadDeEvasion((-10) * n)
			victima.modificarAtaque((-5) * n)
		} else {
			self.terminar()
			
			const congelado = new Congelado(victima = victima, gravedad = 3)
			congelado.aplicar()
		}
	}
}

class Congelado inherits EstadoAlterado {
	override method animacionInicial() = new ImagenEnlazada(
		objetoEnlazado = victima,
		image = "EstadosAlterados/Congelado.png"
	)
	
	override method efectoInicial() = new EventoSimple(
		lista = eventos1Segundo,
		demora = gravedad,
		accion = { victima.curarCongelado() }
	)
	
	method aplicar() {
		victima.estadoDeCongelado().aplicar(self)
	}
	
	method comenzar() {
		victima.deshabilitarAtaque()
		victima.deshabilitarHabilidades()
		victima.comportamientoDeMovimiento(inmobilizadoTotalmente)
		
		victima.congelado(self)
		victima.estadoDeCongelado(tieneEstadoAlterado)
		
		efecto.comenzar()
		game.addVisual(animacion)
	}
	
	method terminar() {
		victima.habilitarAtaque()
		victima.habilitarHabilidades()
		victima.comportamientoDeMovimiento(normal)
		
		victima.congelado(null)
		victima.estadoDeCongelado(noTieneEstadoAlterado)
		
		efecto.interrumpir()
		game.removeVisual(animacion)
	}
	
	method reAplicar() {
		const congeladoAnterior = victima.congelado()
		
		congeladoAnterior.aumentarGravedad(1)
	}
	
	override method aumentarGravedad(n) {
		super(n)
		efecto.modificarDemora(n)
	}
}

class Ceguera inherits EstadoAlterado {
	const duracion = 6
	
	override method animacionInicial() = new ImagenEnlazada(
		objetoEnlazado = victima,
		image = "EstadosAlterados/Ceguera.png"
	)
	
	override method efectoInicial() = new EventoSimple(
		lista = eventos1Segundo,
		demora = duracion,
		accion = { self.terminar() }
	)
	
	method ralentizacion() = 30 + (gravedad * 10)
	
	method aplicar() {
		victima.estadoDeCeguera().aplicar(self)
	}
	
	method comenzar() {
		victima.modificarPresicion((-gravedad) * 10)
		victima.ceguera(self)
		victima.estadoDeCeguera(tieneEstadoAlterado)
		
		efecto.comenzar()
		game.addVisual(animacion)
	}
	
	method reAplicar() {
		const cegueraAnterior = victima.ceguera()
		
		cegueraAnterior.reiniciarDuracion()
		cegueraAnterior.aumentarGravedad(gravedad)
	}
	
	method terminar() {
		efecto.interrumpir()
		victima.modificarPresicion(gravedad * 10)
		victima.ceguera(null)
		victima.estadoDeCeguera(noTieneEstadoAlterado)
		
		game.removeVisual(animacion)
	}
	
	override method aumentarGravedad(n) {
		super(n)
		victima.modificarPresicion((-n) * 10)
	}
}