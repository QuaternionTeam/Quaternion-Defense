import wollok.game.*
import items.items.*
import interfaz.*

object inventarioGeneral {
	const items = new List()
	const maximaCantidadDeItems = 20
	const ancho = 2
	const alto = maximaCantidadDeItems / ancho
	const posicion = game.at(game.width() - 3, game.height() - 4)
	
	method items() = items
	
	method cantidadDeItems() = items.size()
	
	method obtenerItem(n) = if (self.cantidadDeItems() > n) {
		items.get(n)
	} else {
		new NingunItem()
	}
	
	method agregarItem(item) {
		if ((item.nombre() != "Ningun_Equipo") and (item.nombre() != "Puño")) {
			if (items.size() >= maximaCantidadDeItems) self.error(
					("El inventario no puede tener mas de " + maximaCantidadDeItems.toString()) + " items."
				)
			
			items.add(item)
		}
	}
	
	method removerItem(item) {
		items.remove(item)
	}
	
	method limpiar() {
		items.clear()
	}
	
	method generar() {
		var ubicacionEnListaDeItem = 0
		
		alto.times(
			{ dy => ancho.times(
					{ dx =>
						new CasillaItem(ubicacionEnListaDeItem = ubicacionEnListaDeItem).ubicarEn(
							game.at(posicion.x() + dx, posicion.y() - dy)
						)
						ubicacionEnListaDeItem += 1
					}
				) }
		)
	}
	
	method tieneItem(item) = items.any({ _item => _item.esMismoItem(item) })
	
	method mismosItemsQueTiene(item) = items.filter(
		{ _item => _item.esMismoItem(item) }
	)
}

class CasillaItem inherits CasillaDeInventarioEnInterfaz {
	const property ubicacionEnListaDeItem
	
	override method itemEnCasilla() = inventarioGeneral.obtenerItem(
		ubicacionEnListaDeItem
	)
}