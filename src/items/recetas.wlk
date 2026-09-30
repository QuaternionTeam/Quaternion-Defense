import equipos.*
import interfaz.inventarioGeneral.*
import objetosEnJuego.estructuras.*
import recursos.*
import materiales.*
import escenario.*
import consumibles.*

class Receta {
	const property ingredientes
	const property generadorDeProducto
	
	method sePuedeProducirCon(_ingredientes) = ingredientes.all(
		{ ingrediente => _ingredientes.any(
				{ _ingrediente => ingrediente.esMismoItem(
						_ingrediente
					) and (ingrediente.cantidad() <= _ingrediente.cantidad()) }
			) }
	)
	
	method producir(_ingredientes) {
		ingredientes.forEach(
			{ ingrediente => _ingredientes.forEach(
					{ _ingrediente => if (ingrediente.esMismoItem(_ingrediente))
						                 	_ingrediente.quitar(ingrediente.cantidad()) }
				) }
		)
		inventarioGeneral.agregarItem(generadorDeProducto.apply())
	}
}

class RecetaDeEstructura inherits Receta {
	override method producir(_ingredientes) {
		ingredientes.forEach(
			{ ingrediente => _ingredientes.forEach(
					{ _ingrediente => if (ingrediente.esMismoItem(_ingrediente))
						                 	_ingrediente.quitar(ingrediente.cantidad()) }
				) }
		)
		generadorDeProducto.apply().construirEn(
			escenario.sobrevivienteSeleccionado().posicionDeEnFrente()
		)
	}
}
//object recetaEstructuraTest inherits RecetaDeEstructura(ingredientes = #{new Arco(), new MaderaNecesaria(10)}, producto = new EstructuraTest()) {}

object listaDeRecetas {
	// Todas las recetas del juego
	var recetasCache = null
	
	method recetas() {
		if (recetasCache == null) {
			recetasCache = self.crearRecetas()
		}
		return recetasCache
	}
	
	method crearRecetas() = #{
		//Armas
		new Receta(
			ingredientes = #{
				new Palo(cantidad = 10),
				new MaderaNecesaria(cantidad = 15)
			},
			generadorDeProducto = { new EspadaDeEntrenamiento() }
		),
		new Receta(
			ingredientes = #{
				new EspadaDeEntrenamiento(),
				new PiedraNecesaria(cantidad = 25)
			},
			generadorDeProducto = { new Katana() }
		),
		new Receta(
			ingredientes = #{
				new EspadaDeEntrenamiento(),
				new HierroNecesario(cantidad = 25)
			},
			generadorDeProducto = { new EspadaCorta() }
		),
		new Receta(
			ingredientes = #{
				new Palo(cantidad = 10),
				new HierroNecesario(cantidad = 15)
			},
			generadorDeProducto = { new EspadaRecta() }
		),
		new Receta(
			ingredientes = #{new EspadaRecta(), new HierroNecesario(cantidad = 25)},
			generadorDeProducto = { new EspadaGrande() }
		),
		new Receta(
			ingredientes = #{new EspadaGrande(), new AlasDeAngel()},
			generadorDeProducto = { new AngelGuardian() }
		),
		new Receta(
			ingredientes = #{new Palo(cantidad = 20), new Cuerda(cantidad = 5)},
			generadorDeProducto = { new Arco() }
		),
		//Equipos De Mano
		new Receta(
			ingredientes = #{
				new MaderaNecesaria(cantidad = 30),
				new PiedraNecesaria(cantidad = 30)
			},
			generadorDeProducto = { new EscudoRedondo() }
		),
		new Receta(
			ingredientes = #{new BrazaleteDeOro(), new Diamante(cantidad = 10)},
			generadorDeProducto = { new AnilloLujoso() }
		),
		new Receta(
			ingredientes = #{
				new OroNecesario(cantidad = 30),
				new HierroNecesario(cantidad = 30)
			},
			generadorDeProducto = { new BrazaleteDeOro() }
		),
		//Cascos
		new Receta(
			ingredientes = #{new OroNecesario(cantidad = 25), new Cuerda(cantidad = 3)},
			generadorDeProducto = { new CollarDeOro() }
		),
		new Receta(
			ingredientes = #{new Garra(cantidad = 10), new Cuerda(cantidad = 3)},
			generadorDeProducto = { new CollarSalvaje() }
		),
		new Receta(
			ingredientes = #{new Cuero(cantidad = 10), new Cuerda(cantidad = 3)},
			generadorDeProducto = { new CascoDeCuero() }
		),
		new Receta(
			ingredientes = #{new Rubi(cantidad = 15), new CascoDeCuero()},
			generadorDeProducto = { new CascoDePaladin() }
		),
		new Receta(
			ingredientes = #{new CollarSalvaje(), new CascoDeCuero()},
			generadorDeProducto = { new CascoDeGladiador() }
		),
		//Pecheras
		new Receta(
			ingredientes = #{new Cuero(cantidad = 10), new HierbaVerde(cantidad = 10)},
			generadorDeProducto = { new CamisaVerde() }
		),
		new Receta(
			ingredientes = #{new Cuero(cantidad = 10), new Rubi(cantidad = 10)},
			generadorDeProducto = { new CamisaAzul() }
		),
		new Receta(
			ingredientes = #{new Cuero(cantidad = 10), new CamisaVerde()},
			generadorDeProducto = { new ArmaduraLigeraDeCuero() }
		),
		new Receta(
			ingredientes = #{new CamisaVerde(), new HierroNecesario(cantidad = 20)},
			generadorDeProducto = { new ArmaduraLigeraDeHierro() }
		),
		new Receta(
			ingredientes = #{new CamisaAzul(), new Rubi(cantidad = 15)},
			generadorDeProducto = { new ArmaduraDePaladin() }
		),
		new Receta(
			ingredientes = #{new CamisaAzul(), new HierroNecesario(cantidad = 35)},
			generadorDeProducto = { new ArmaduraPesada() }
		),
		new Receta(
			ingredientes = #{new Pluma(cantidad = 25), new Diamante(cantidad = 5)},
			generadorDeProducto = { new AlasDeAngel() }
		),
		//Pantalones
		new Receta(
			ingredientes = #{new Calzoncillos(), new Pluma(cantidad = 10)},
			generadorDeProducto = { new PantalonesCortos() }
		),
		new Receta(
			ingredientes = #{new Calzoncillos(), new Cuero(cantidad = 10)},
			generadorDeProducto = { new PantalonesLargos() }
		),
		//Botas
		new Receta(
			ingredientes = #{new BotasViejas(), new Cuero(cantidad = 15)},
			generadorDeProducto = { new BotasDeCuero() }
		),
		new Receta(
			ingredientes = #{new BotasViejas(), new HierroNecesario(cantidad = 25)},
			generadorDeProducto = { new BotasDeHierro() }
		),
		//Estructuras
		new RecetaDeEstructura(
			ingredientes = #{new EscudoRedondo(), new MaderaNecesaria(cantidad = 50)},
			generadorDeProducto = { new MuroDeMadera() }
		),
		new RecetaDeEstructura(
			ingredientes = #{new EscudoRedondo(), new PiedraNecesaria(cantidad = 50)},
			generadorDeProducto = { new MuroDePiedra() }
		),
		new RecetaDeEstructura(
			ingredientes = #{new Arco(), new PiedraNecesaria(cantidad = 50)},
			generadorDeProducto = { new TorreDePiedra() }
		)
	}
	
	method combinar(ingredienteUno, ingredienteDos) {
		const ingredientes = #{ingredienteUno, ingredienteDos}
		const recetaDeCombinacion = self.recetas().filter(
			{ receta => receta.ingredientes().all(
					{ ingrediente => ingrediente.esMismoItem(
							ingredienteUno
						) or ingrediente.esMismoItem(ingredienteDos) }
				) }
		)
		
		if ((not recetaDeCombinacion.isEmpty()) and recetaDeCombinacion.uniqueElement().sePuedeProducirCon(
				ingredientes
			)) recetaDeCombinacion.uniqueElement().producir(ingredientes)
	}
}