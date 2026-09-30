import wollok.game.*
import objetosEnJuego.objetosEnJuego.*
import interfaz.inventarioGeneral.*
import interfaz.interfaz.*
import interfaz.cursores.*
import interfaz.mensaje.*
import recetas.*
import escenario.*

class Item inherits ObjetoEnJuego {
	method nombre()
	
	method interactuar()
	
	method esMismoItem(item) = item.nombre() == self.nombre()
	
	method combinar() {
		interfaz.itemACombinar().combinarCon(self)
	}
	
	method combinarCon(item) {
		listaDeRecetas.combinar(item, self)
		interfaz.terminarCrafteo()
	}
	
	method agregarAInventario()
	
	method numeroAMostrar()
	
	override method image() = ("assets/" + self.direccion()) + ".png"
	
	method direccion() = "Items/"
	
	method informacion() = self.direccion()
}

class ItemAcumulable inherits Item {
	var property cantidad = 1
	
	method agregar(cantidadAgregada) {
		cantidad += cantidadAgregada
	}
	
	method quitar(cantidadAQuitar) {
		cantidad = 0.max(cantidad - cantidadAQuitar)
	}
	
	method cantidad() = cantidad
	
	override method numeroAMostrar() = cantidad
}

class ItemAcumulableLimitado inherits ItemAcumulable {
	const limite = 16
	
	override method agregar(cantidadAgregada) {
		if ((cantidad + cantidadAgregada) > limite) {
			var sobrante = cantidadAgregada - (limite - cantidad)
			
			cantidad = limite
			
			var nuevoItem = self.nuevoYo()
			
			nuevoItem.agregarAInventario()
			nuevoItem.agregar(sobrante - 1)
		} else {
			cantidad += cantidadAgregada
		}
	}
	
	override method agregarAInventario() {
		if (inventarioGeneral.tieneItem(
				self
			) and inventarioGeneral.mismosItemsQueTiene(self).any(
				{ item => not item.estaLleno() }
			)) inventarioGeneral.mismosItemsQueTiene(self).filter(
				{ item => not item.estaLleno() }
			).head().agregar(self.cantidad())
		else inventarioGeneral.agregarItem(self)
	}
	
	method estaLleno() = limite == cantidad
	
	method nuevoYo()
}

class NingunItem inherits Item {
	override method nombre() = "Ningun_Item"
	
	override method interactuar() {
		
	}
	
	override method combinar() {
		
	}
	
	// Al no haber item para combinar, se establece como iteam a combinar al item seleccionado y se agrega el cursor
	override method combinarCon(item) {
		interfaz.itemACombinar(item)
		cursorItemACombinar.position(cursorDeInventario.position())
		game.addVisual(cursorItemACombinar)
	}
	
	override method agregarAInventario() {
		
	}
	
	override method numeroAMostrar() = 0
	
	override method direccion() = super() + self.nombre()
}