import items.*

class Recurso inherits ItemAcumulable {
	method reiniciar() {
		cantidad = 0
	}
	
	override method agregarAInventario() {
		
	}
	
	override method interactuar() {
		
	}
	
	override method direccion() = (super() + "Recursos/") + self.nombre()
}

object madera inherits Recurso (cantidad = 0) {
	override method nombre() = "Madera"
}

object piedra inherits Recurso (cantidad = 0) {
	override method nombre() = "Piedra"
}

object hierro inherits Recurso (cantidad = 0) {
	override method nombre() = "Hierro"
}

object oro inherits Recurso (cantidad = 0) {
	override method nombre() = "Oro"
}

class RecursoNecesario {
	const property cantidad
	
	method esMismoItem(item)
}

class MaderaNecesaria inherits RecursoNecesario {
	override method esMismoItem(_madera) = _madera is madera
}

class PiedraNecesaria inherits RecursoNecesario {
	override method esMismoItem(_piedra) = _piedra is piedra
}

class OroNecesario inherits RecursoNecesario {
	override method esMismoItem(_oro) = _oro is oro
}

class HierroNecesario inherits RecursoNecesario {
	override method esMismoItem(_hierro) = _hierro is hierro
}