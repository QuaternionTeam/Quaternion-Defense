import wollok.game.*
import objetosEnJuego.objetosEnJuego.*
import objetosEnJuego.imagenEnlazada.*
import escenario.*
import sonidos.*

class Cursor inherits ObjetoEnJuego {
	var property position = game.origin()
	
	method agregar() {
		game.addVisual(self)
	}
	
	method quitar() {
		game.removeVisual(self)
	}
}

object cursorItemACombinar inherits Cursor {
	override method image() = "assets/Interfaz/Cursores/Cursor_Item_A_Combinar.png"
}

object cursorSobrevivienteSeleccionado inherits ImagenEnlazada (
	objetoEnlazado = null
) {
	method agregar() {
		game.addVisual(self)
	}
	
	method quitar() {
		game.removeVisual(self)
	}
	
	override method objetoEnlazado() = escenario.sobrevivienteSeleccionado()
	
	override method image() = "assets/Interfaz/Cursores/Cursor_Sobreviviente_Seleccionado.png"
}

object cursorDeInventario inherits Cursor (position = game.at(game.width() - 2, game.height() - 2)) {
	
	// MOVIMIENTO
	// Mueve el cursor a la nueva posicion sin salir del inventario
	method mover(nuevaPosicion) {
		if (nuevaPosicion.x().between(
			game.width() - 2,
			game.width() - 1
		) and nuevaPosicion.y().between(1, game.height() - 2)) {
			position = nuevaPosicion
			sonido.reproducir("Cursor.wav")
		}
	}
	
	// Maniobra para obtener el item bajo el cursor
	method itemSeleccionado() = self.position().allElements().reverse().copyWithout(
		cursorItemACombinar
	).get(4).itemEnCasilla()
	
	// Mueve al cursor en un sentido
	method moverArriba() {
		self.mover(position.up(1))
	}
	
	method moverAbajo() {
		self.mover(position.down(1))
	}
	
	method moverIzquierda() {
		self.mover(position.left(1))
	}
	
	method moverDerecha() {
		self.mover(position.right(1))
	}
	
	override method image() = "assets/Interfaz/Cursores/Cursor_Inventario.png"
}