import wollok.game.*
import objetosEnJuego.*
import eventos.*
import escenario.*

class Drop inherits ObjetoEnJuego {
	const property item
	const property position
	const property fondo = escenario.fondo(position)
	const property tiempo = new EventoSimple(
		lista = eventos1Segundo,
		demora = 10,
		accion = { self.desaparecer() }
	)
	
	method serAgarrado() {
		item.agregarAInventario()
		self.desaparecer()
	}
	
	method aparecer() {
		game.addVisual(self)
		tiempo.comenzar()
		
		fondo.agregarDrop(self)
	}
	
	method desaparecer() {
		tiempo.interrumpir()
		fondo.removerDrop()
		game.removeVisual(self)
	}
	
	override method image() = item.image()
}