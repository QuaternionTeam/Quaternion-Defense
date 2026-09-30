import wollok.game.*
import pantalla.*
import interfaz.*
import items.recursos.*

object inventarioDeRecursos {
	const posicion = game.at(pantalla.ancho() - 2, 2)
	
	method generar() {
		new CasillaRecurso(recurso = madera).ubicarEn(
			game.at(posicion.x(), posicion.y())
		)
		new CasillaRecurso(recurso = piedra).ubicarEn(
			game.at(posicion.x() + 1, posicion.y())
		)
		new CasillaRecurso(recurso = hierro).ubicarEn(
			game.at(posicion.x(), posicion.y() - 1)
		)
		new CasillaRecurso(recurso = oro).ubicarEn(
			game.at(posicion.x() + 1, posicion.y() - 1)
		)
	}
	
	method reiniciarRecursos() {
		madera.reiniciar()
		piedra.reiniciar()
		hierro.reiniciar()
		oro.reiniciar()
	}
}

class CasillaRecurso inherits CasillaDeInventarioEnInterfaz {
	const property recurso
	
	override method itemEnCasilla() = recurso
}