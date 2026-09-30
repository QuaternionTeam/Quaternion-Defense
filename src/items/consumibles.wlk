import interfaz.inventarioGeneral.*
import escenario.*
import items.*

class Consumible inherits ItemAcumulableLimitado {
	override method interactuar() {
		self.consumir(escenario.sobrevivienteSeleccionado())
	}
	
	method consumir(consumidor) {
		self.efecto(consumidor)
		cantidad -= 1
		
		self.removerDeInventarioSiSeTermino()
	}
	
	override method quitar(cantidadAQuitar) {
		super(cantidadAQuitar)
		self.removerDeInventarioSiSeTermino()
	}
	
	method removerDeInventarioSiSeTermino() {
		if (cantidad == 0) inventarioGeneral.removerItem(self)
	}
	
	method efecto(consumidor)
	
	override method direccion() = (super() + "Consumibles/") + self.nombre()
}

class HierbaVerde inherits Consumible {
	override method nombre() = "Hierba_Verde"
	
	override method efecto(consumidor) {
		consumidor.curar(consumidor.porcentajeDeVidaMaxima(15))
	}
	
	override method nuevoYo() = new HierbaVerde()
}