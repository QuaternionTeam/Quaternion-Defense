import wollok.game.*
import escenario.*
import contadores.*
import interfaz.*

object inventarioDeEquipos {
	const property alto = 3
	const property ancho = 2
	const posicion = game.at(game.width() - 2, game.height() - 2)
	
	method generar() {
		casillaArma.ubicarEn(posicion)
		casillaEquipoDeMano.ubicarEn(game.at(posicion.x() + 1, posicion.y()))
		casillaCasco.ubicarEn(game.at(posicion.x(), posicion.y() - 1))
		casillaPechera.ubicarEn(game.at(posicion.x() + 1, posicion.y() - 1))
		casillaPantalones.ubicarEn(game.at(posicion.x(), posicion.y() - 2))
		casillaBotas.ubicarEn(game.at(posicion.x() + 1, posicion.y() - 2))
	}
}

object casillaArma inherits CasillaDeInventarioEnInterfaz {
	override method itemEnCasilla() = escenario.sobrevivienteSeleccionado().arma()
}

object casillaEquipoDeMano inherits CasillaDeInventarioEnInterfaz {
	override method itemEnCasilla() = escenario.sobrevivienteSeleccionado().equipoDeMano()
}

object casillaCasco inherits CasillaDeInventarioEnInterfaz {
	override method itemEnCasilla() = escenario.sobrevivienteSeleccionado().casco()
}

object casillaPechera inherits CasillaDeInventarioEnInterfaz {
	override method itemEnCasilla() = escenario.sobrevivienteSeleccionado().pechera()
}

object casillaPantalones inherits CasillaDeInventarioEnInterfaz {
	override method itemEnCasilla() = escenario.sobrevivienteSeleccionado().pantalones()
}

object casillaBotas inherits CasillaDeInventarioEnInterfaz {
	override method itemEnCasilla() = escenario.sobrevivienteSeleccionado().botas()
}