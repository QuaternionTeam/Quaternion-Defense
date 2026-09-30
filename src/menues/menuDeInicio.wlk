import wollok.game.*
import sonidos.*
import teclado.*
import menuDePreparacion.*
import eventos.*

object menuDeInicio {
	var estado = 0
	
	method generar() {
		teclado.cambiarEstado(estadoMenuDeInicio)
		game.onTick(400, "Animacion_Menu", { self.avanzarAnimacion() })
		
		game.addVisual(self)
		game.addVisual(titulo)
	}
	
	method position() = game.origin()
	
	method cerrar() {
		game.removeTickEvent("Animacion_Menu")
		game.allVisuals().forEach({ visual => game.removeVisual(visual) })
	}
	
	method continuar() {
		self.cerrar()
		sonido.reproducir("Cursor.wav")
		menuDePreparacion.generar()
	}
	
	method image() = ("assets/Interfaz/MenuDeInicio/Menu_Animacion_" + estado) + ".png"
	
	method avanzarAnimacion() {
		estado += 1
		if (estado >= 7) {
			estado = 0
		}
	}
}

object titulo {
	method position() = game.origin()
	method image() = "assets/Interfaz/MenuDeInicio/TituloQuaternionDefense.png"
}