import wollok.game.*
import escenario.*
import contadores.*
import personajes.habilidades.*

object barraDeHabilidades {
	const posicion = game.at(5, game.height() - 1)
	
	method generar() {
		const cantHabilidadesActivas = 3
		const cantHabilidadesPasivas = 3
		
		cantHabilidadesActivas.times(
			{ num => new CasillaHabilidadActiva(numeroDeHabilidad = num - 1).ubicar(
					game.at(posicion.x() + num, posicion.y())
				) }
		)
		cantHabilidadesPasivas.times(
			{ num => new CasillaHabilidadPasiva(numeroDeHabilidad = num - 1).ubicar(
					game.at((posicion.x() + num) + cantHabilidadesActivas, posicion.y())
				) }
		)
	}
}

class CasillaHabilidad {
	var property numeroDeHabilidad
	var property position = game.origin()
	
	//method enfriamientoDeHabilidad() = self.habilidadEnCasilla().momentoDeEnfriamiento()
	method ubicar(_position) {
		position = _position
		game.addVisual(self)
		game.addVisual(
			new DosDigitos_Unidad(
				objetoConNumero = self,
				comportamientoDeCero = mostrarTodosLosCerosSiNoEsCero,
				position = position
			)
		)
		game.addVisual(
			new DosDigitos_Decena(
				objetoConNumero = self,
				comportamientoDeCero = mostrarTodosLosCerosSiNoEsCero,
				position = position
			)
		)
	}
	
	method habilidadEnCasilla()
	
	method numeroAMostrar() = self.habilidadEnCasilla().momentoDeEnfriamiento()
	
	method image() = self.habilidadEnCasilla().image()
}

class CasillaHabilidadActiva inherits CasillaHabilidad {
	override method habilidadEnCasilla() = escenario.sobrevivienteSeleccionado().habilidadActiva(
		numeroDeHabilidad
	)
}

class CasillaHabilidadPasiva inherits CasillaHabilidad {
	override method habilidadEnCasilla() = escenario.sobrevivienteSeleccionado().habilidadPasiva(
		numeroDeHabilidad
	)
}