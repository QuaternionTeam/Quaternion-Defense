import items.*

class Material inherits ItemAcumulableLimitado {
	override method interactuar() {
		
	}
	
	override method direccion() = (super() + "Materiales/") + self.nombre()
}

class Diamante inherits Material {
	override method nombre() = "Diamante"
	
	override method nuevoYo() = new Diamante()
}

class Rubi inherits Material {
	override method nombre() = "Rubi"
	
	override method nuevoYo() = new Rubi()
}

class Palo inherits Material {
	override method nombre() = "Palo"
	
	override method nuevoYo() = new Palo()
}

class Cuerda inherits Material {
	override method nombre() = "Cuerda"
	
	override method nuevoYo() = new Cuerda()
}

class Cuero inherits Material {
	override method nombre() = "Cuero"
	
	override method nuevoYo() = new Cuero()
}

class Garra inherits Material {
	override method nombre() = "Garra"
	
	override method nuevoYo() = new Garra()
}

class Pluma inherits Material {
	override method nombre() = "Pluma"
	
	override method nuevoYo() = new Pluma()
}