import wollok.game.*
import pantalla.*
import datosEnPartida.*
import barraDeHabilidades.*
import inventarioDeEquipos.*
import inventarioGeneral.*
import inventarioDeRecursos.*
import objetosEnJuego.fondos.*
import cursores.*
import contadores.*
import items.items.*
import items.equipos.*

object interfaz {
	const ancho = pantalla.ancho()
	const alto = pantalla.alto()
	var itemACombinar = null
	
	method itemACombinar() = if (itemACombinar == null) {
		new NingunItem()
	} else {
		itemACombinar
	}
	
	method itemACombinar(item) {
		itemACombinar = item
	}
	
	method crearCasillaInterfaz(x, y, imagen) {
		new FondoInterfaz(imagen = imagen).ubicar(x, y)
	}
	
	method crearCasillaMarcoInventario(x, y) {
		const casillaInventario = new FondoInterfaz(
			imagen = "Interfaz_Marco",
			position = game.at(x, y)
		)
		game.addVisual(casillaInventario)
	}
	
	method generar() {
		(ancho - 3).times(
			{ num =>
				// Fondos primera y última fila
				self.crearCasillaInterfaz(num, alto - 1, "Interfaz_Fondo")
				self.crearCasillaInterfaz(num, 0, "Interfaz_Fondo")
				
				// Bordes primera y última fila
				self.crearCasillaInterfaz(num, alto - 1, "Interfaz_Horizontal")
				return self.crearCasillaInterfaz(num, 0, "Interfaz_Horizontal")
			}
		)
		
		
		(alto - 2).times(
			{ num =>
				// Fondos primera y 2 últimas columnas
				self.crearCasillaInterfaz(0, num, "Interfaz_Fondo")
				self.crearCasillaInterfaz(ancho - 1, num, "Interfaz_Fondo")
				self.crearCasillaInterfaz(ancho - 2, num, "Interfaz_Fondo")
				return // Bordes primera columna
				self.crearCasillaInterfaz(0, num, "Interfaz_Vertical")
			}
		)
		
		// Genera otras casillas con sus fondos y bordes
		self.crearCasillaInterfaz(0, 0, "Interfaz_Fondo")
		self.crearCasillaInterfaz(
			0,
			0,
			"Interfaz_Esquina_Inferior_Izquierda_Con_Punto"
		)
		
		self.crearCasillaInterfaz(ancho - 1, 0, "Interfaz_Fondo")
		self.crearCasillaInterfaz(ancho - 1, 0, "Interfaz_Horizontal")
		self.crearCasillaInterfaz(ancho - 1, 0, "Interfaz_Esquina_Inferior_Derecha")
		
		self.crearCasillaInterfaz(ancho - 2, 0, "Interfaz_Fondo")
		self.crearCasillaInterfaz(ancho - 2, 0, "Interfaz_Horizontal")
		
		self.crearCasillaInterfaz(0, alto - 1, "Interfaz_Fondo")
		self.crearCasillaInterfaz(
			0,
			alto - 1,
			"Interfaz_Esquina_Superior_Izquierda_Con_Punto"
		)
		
		self.crearCasillaInterfaz(ancho - 1, alto - 1, "Interfaz_Fondo")
		self.crearCasillaInterfaz(ancho - 1, alto - 1, "Interfaz_Horizontal")
		self.crearCasillaInterfaz(
			ancho - 1,
			alto - 1,
			"Interfaz_Esquina_Superior_Derecha"
		)
		
		self.crearCasillaInterfaz(ancho - 2, alto - 1, "Interfaz_Fondo")
		self.crearCasillaInterfaz(ancho - 2, alto - 1, "Interfaz_Horizontal")
		
		// Genera marcos y bordes habilidades
		6.times(
			{ num => self.crearCasillaInterfaz(5 + num, alto - 1, "Interfaz_Marco") }
		)
		self.crearCasillaInterfaz(
			6,
			pantalla.alto() - 1,
			"Interfaz_Vertical_Izquierda"
		)
		self.crearCasillaInterfaz(
			11,
			pantalla.alto() - 1,
			"Interfaz_Vertical_Derecha"
		)
		
		// Genera bordes y marcos equipos
		3.times(
			{ num =>
				self.crearCasillaInterfaz(
					ancho - 1,
					(alto - num) - 1,
					"Interfaz_Vertical_Derecha"
				)
				self.crearCasillaInterfaz(
					ancho - 2,
					(alto - num) - 1,
					"Interfaz_Vertical_Izquierda"
				)
				self.crearCasillaMarcoInventario(ancho - 1, (alto - num) - 1)
				return self.crearCasillaMarcoInventario(ancho - 2, (alto - num) - 1)
			}
		)
		
		// Genera bordes y marcos para inventario
		10.times(
			{ num =>
				self.crearCasillaInterfaz(
					ancho - 1,
					(alto - num) - 4,
					"Interfaz_Vertical_Derecha"
				)
				self.crearCasillaInterfaz(
					ancho - 2,
					(alto - num) - 4,
					"Interfaz_Vertical_Izquierda"
				)
				self.crearCasillaMarcoInventario(ancho - 1, (alto - num) - 4)
				return self.crearCasillaMarcoInventario(ancho - 2, (alto - num) - 4)
			}
		)
		self.crearCasillaInterfaz(ancho - 1, alto - 5, "Interfaz_Horizontal_Arriba")
		self.crearCasillaInterfaz(ancho - 2, alto - 5, "Interfaz_Horizontal_Arriba")
		self.crearCasillaInterfaz(ancho - 1, alto - 14, "Interfaz_Horizontal_Abajo")
		self.crearCasillaInterfaz(ancho - 2, alto - 14, "Interfaz_Horizontal_Abajo")
		
		// Genera bordes y marcos para recursos
		2.times(
			{ num =>
				self.crearCasillaInterfaz(ancho - 1, num, "Interfaz_Vertical_Derecha")
				self.crearCasillaInterfaz(ancho - 2, num, "Interfaz_Vertical_Izquierda")
				self.crearCasillaMarcoInventario(ancho - 1, num)
				return self.crearCasillaMarcoInventario(ancho - 2, num)
			}
		)
		
		barraDeHabilidades.generar()
		inventarioDeEquipos.generar()
		inventarioGeneral.generar()
		inventarioDeRecursos.generar()
		
		textoDeNivel.ubicar()
		textoDeExperiencia.ubicar()
		
		// Agrega el cursors
		cursorDeInventario.agregar()
		// Genera barras horizontales
		// Genera barras verticales
	}
	
	method terminarCrafteo() {
		if (game.hasVisual(cursorItemACombinar)) game.removeVisual(
				cursorItemACombinar
			)
		itemACombinar = null
	}
}

class CasillaDeInventarioEnInterfaz {
	var property position = game.origin()
	
	method ubicarEn(_position) {
		position = _position
		game.addVisual(self)
		game.addVisual(
			new TresDigitos_Unidad(
				objetoConNumero = self,
				comportamientoDeCero = noMostrarCero,
				position = position
			)
		)
		game.addVisual(
			new TresDigitos_Decena(
				objetoConNumero = self,
				comportamientoDeCero = noMostrarCero,
				position = position
			)
		)
		game.addVisual(
			new TresDigitos_Centena(
				objetoConNumero = self,
				comportamientoDeCero = noMostrarCero,
				position = position
			)
		)
	}
	
	method numeroAMostrar() = self.itemEnCasilla().numeroAMostrar()
	
	method itemEnCasilla()
	
	method image() = self.itemEnCasilla().image()
}