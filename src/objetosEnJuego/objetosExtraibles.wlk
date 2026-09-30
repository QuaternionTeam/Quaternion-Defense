import wollok.game.*
import objetosDeInteraccion.*
import items.recursos.*
import items.consumibles.*
import items.materiales.*
import probabilidad.*

/******************** Objetos Extraibles ********************/
class ObjetoExtraible inherits ObjetoDeInteraccion {
	const property recursoExtraible
	const property itemRaro = null
	const property cantidadTotal
	var property cantidadActual
	
	// Extrae suemore y cuando haya cantidad para extraer y se remueve el visual al terminarse
	method extraer(cantidadAExtraer) {
		if (cantidadActual >= cantidadAExtraer) {
			recursoExtraible.agregar(cantidadAExtraer)
			cantidadActual -= cantidadAExtraer
		} else {
			recursoExtraible.agregar(cantidadActual)
			cantidadActual = 0
		}
		
		
		
		// Si es posible obtener un item raro hay un 2% de posibilidad de obtenerlo en cada extraccion
		if ((itemRaro != null) and probabilidad.en100De(2))
			itemRaro.agregarAInventario()
	}
	
	override method total() = cantidadTotal
	
	override method progreso() = cantidadTotal - cantidadActual
}

class Arbol inherits ObjetoExtraible (
	recursoExtraible = madera,
	cantidadTotal = 50,
	cantidadActual = 50
) {
	override method image() = null
	
	override method extraer(cantidadAExtraer) {
		super(cantidadAExtraer)
		
		
		// Si es posible obtener un item raro hay un 20% de posibilidad de obtenerlo en cada extraccion
		if (probabilidad.en100De(20)) new Palo(cantidad = 1).agregarAInventario()
	}
	
	override method progresar() {
		self.extraer(interactores.size())
	}
	
	override method terminar() {
		super()
		game.removeVisual(self)
	}
}

class ArbolVerde inherits Arbol (
	itemRaro = new HierbaVerde(cantidad = 0.randomUpTo(3).roundUp())
) {
	const property numero
	
	override method image() = ("Terreno/Recursos/Arbol_1_" + numero) + ".png"
}

class ArbolVerdeOscuro inherits Arbol (
	itemRaro = new HierbaVerde(cantidad = 0.randomUpTo(3).roundUp())
) {
	const property numero
	
	override method image() = ("Terreno/Recursos/Arbol_2_" + numero) + ".png"
}

class ArbolNaranja inherits Arbol (
	itemRaro = new HierbaVerde(cantidad = 0.randomUpTo(3).roundUp())
) {
	const property numero
	
	override method image() = ("Terreno/Recursos/Arbol_3_" + numero) + ".png"
}

class ArbolNevado inherits Arbol (
	itemRaro = new HierbaVerde(cantidad = 0.randomUpTo(3).roundUp())
) {
	const property numero
	
	override method image() = ("Terreno/Recursos/Arbol_4_" + numero) + ".png"
}

class ArbolPelado inherits Arbol (
	itemRaro = new HierbaVerde(cantidad = 0.randomUpTo(3).roundUp())
) {
	const property numero
	
	override method image() = ("Terreno/Recursos/Arbol_5_" + numero) + ".png"
}

class Roca inherits ObjetoExtraible (
	recursoExtraible = piedra,
	cantidadTotal = 50,
	cantidadActual = 50,
	itemRaro = new Rubi()
) {
	const property tipo = [1, 2].anyOne()
	
	override method progresar() {
		self.extraer(interactores.size())
	}
	
	override method terminar() {
		super()
		game.removeVisual(self)
	}
	
	override method esAtravesable() = false
	
	override method image() = ("Terreno/Recursos/Roca_" + tipo) + ".png"
}

class MinaDeHierro inherits ObjetoExtraible (
	recursoExtraible = hierro,
	cantidadTotal = 25,
	cantidadActual = 25,
	itemRaro = new Diamante()
) {
	override method progresar() {
		self.extraer(interactores.size())
	}
	
	override method terminar() {
		super()
		game.removeVisual(self)
	}
	
	override method esAtravesable() = false
	
	override method image() = "Terreno/Recursos/Mina_De_Hierro.png"
}

class MinaDeOro inherits ObjetoExtraible (
	recursoExtraible = oro,
	cantidadTotal = 25,
	cantidadActual = 25,
	itemRaro = new Diamante()
) {
	override method progresar() {
		self.extraer(interactores.size())
	}
	
	override method terminar() {
		super()
		game.removeVisual(self)
	}
	
	override method esAtravesable() = false
	
	override method image() = "Terreno/Recursos/Mina_De_Oro.png"
}