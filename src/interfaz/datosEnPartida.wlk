import wollok.game.*
import escenario.*
import contadores.*

object textoDeNivel {
	const posicion = game.at(1, game.height() - 1)
	
	method position() = posicion
	
	method ubicar() {
		var posicionDeAlLado = game.at(posicion.x() + 2, posicion.y())
		
		game.addVisual(self)
		game.addVisual(
			new DosDigitos_Unidad(
				objetoConNumero = escenario,
				comportamientoDeCero = mostrarUltimoCero,
				position = posicionDeAlLado
			)
		)
		game.addVisual(
			new DosDigitos_Decena(
				objetoConNumero = escenario,
				comportamientoDeCero = mostrarUltimoCero,
				position = posicionDeAlLado
			)
		)
	}
	
	method image() = "Interfaz/DatosEnPartida/Nivel.png"
}

object textoDeExperiencia {
	const posicion = game.at(13, game.height() - 1)
	
	method position() = posicion
	
	method ubicar() {
		var posicionDeAlLado = game.at(posicion.x() + 1, posicion.y())
		
		game.addVisual(self)
		game.addVisual(
			new DosDigitos_Unidad(
				objetoConNumero = nivelDeSobrevivienteSeleccinoado,
				comportamientoDeCero = mostrarUltimoCero,
				position = posicionDeAlLado
			)
		)
		game.addVisual(
			new DosDigitos_Decena(
				objetoConNumero = nivelDeSobrevivienteSeleccinoado,
				comportamientoDeCero = mostrarUltimoCero,
				position = posicionDeAlLado
			)
		)
	}
	
	method image() = "Interfaz/DatosEnPartida/Exp.png"
}

object nivelDeSobrevivienteSeleccinoado {
	method numeroAMostrar() = escenario.sobrevivienteSeleccionado().nivel()
}