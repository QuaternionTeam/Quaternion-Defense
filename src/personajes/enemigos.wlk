import wollok.game.*
import items.equipos.*
import personajes.*
import escenario.*
import direcciones.*
import probabilidad.*
import habilidades.*
import eventos.*
import objetosEnJuego.drops.*
import items.materiales.*
import items.consumibles.*

/******************** Clase Enemigo ********************/
class Enemigo inherits Personaje {
	const property dropsPosibles = self.dropsPosiblesIniciales()
	
	method dropsPosiblesIniciales() = []
	
	/******************** Estadisticas ********************/
	override method ataque() = (ataque + (1.5 * escenario.nroHorda())) + (3 * escenario.nivel())
	
	override method defensa() = (defensa + escenario.nroHorda()) + (2 * escenario.nivel())
	
	override method vidaMaxima() = (vidaMaxima + (2 * escenario.nroHorda())) + (10 * escenario.nivel())
	
	/******************** Combate ********************/
	method multiplicadorDeDanio() = 15
	
	// Verdadero si hay objetivo en el rango de ataque
	method haySobrevivientesEnRango() = escenario.sobrevivientes().any(
		{ sobreviviente => arma.estaEnRango(
				sobreviviente
			) and sobreviviente.esAtacable() }
	)
	
	method hayEstructurasEnRango() = escenario.estructuras().any(
		{ estructura => arma.estaEnRango(estructura) }
	)
	
	override method hayObjetivosEnRango() = self.haySobrevivientesEnRango() or self.hayEstructurasEnRango()
	
	// Posibles objetivos en rango
	method sobrevivienteEnRango() = escenario.sobrevivientes().filter(
		{ sobreviviente => arma.estaEnRango(sobreviviente) }
	).anyOne()
	
	method estructuraEnRango() = escenario.estructuras().filter(
		{ estructura => arma.estaEnRango(estructura) }
	).anyOne()
	
	// Obtiene un objetivo dentro del rango de ataque
	override method objetivoEnRango() {
		var objetivo = null
		
		if (self.haySobrevivientesEnRango()) {
			objetivo = self.sobrevivienteEnRango()
		} else {
			if (self.hayEstructurasEnRango()) {
				objetivo = self.estructuraEnRango()
			}
		}
		
		return objetivo
	}
	
	method drop() = new Drop(
		item = dropsPosibles.anyOne(),
		position = self.position()
	)
	
	override method efectoAlMorir(asesino) {
		self.drop().aparecer()
		escenario.removerEnemigo(self)
	}
	
	/******************** IA ********************/
	method obtenerSobrevivienteMasCercano() = escenario.sobrevivientes().min(
		{ sobreviviente => position.distance(sobreviviente.position()) }
	)
	
	method direccionesAtravesables() = [izquierda, arriba, abajo, derecha].filter(
		{ direccion => escenario.esAtravesable(direccion.posicion(position)) }
	)
	
	method direccionMasConveniente(direcciones, objetivo) = direcciones.min(
		{ direccion => direccion.posicion(position).distance(objetivo.position()) }
	)
	
	method moverHaciaSobrevivienteCercano() {
		if (not escenario.sobrevivientes().isEmpty()) {
			var objetivo = self.obtenerSobrevivienteMasCercano()
			
			var direccionesAtravesables = self.direccionesAtravesables()
			if (not direccionesAtravesables.isEmpty()) {
				var direccionMasConveniente = self.direccionMasConveniente(
					direccionesAtravesables,
					objetivo
				)
				self.moverHaciaSiEsPosible(direccionMasConveniente)
			}
		}
	}
	
	method movimientoYAtaque() {
		// Ataca si tiene objetivos si no hay objetivos de ataque se mueve
		if (self.hayObjetivosEnRango()) self.atacarA(self.objetivoEnRango())
		else self.moverHaciaSobrevivienteCercano()
	}
	
	/******************** Eventos ********************/
	// Gestiona todos los eventos 
	override method eventos() = [
		new EventoPeriodico(
			lista = eventos1Segundo,
			periodo = self.tiempoDeAccion(),
			accion = { self.movimientoYAtaque() }
		)
	]
	
	/******************** Otros ********************/
	method agarrarDrop(drop) {
		drop.desaparecer()
	}
	
	override method inicializar() {
		super()
		orientacion = izquierda
	}
	
	override method image() = ((("Personajes/Enemigos/" + self.nombre()) + "/") + self.estadoDeAnimacion()) + ".png"
}

class ZombieTipo1 inherits Enemigo {
	override method armaInicial() = new GarraZombiePerforante(usuario = self)
	
	override method ataqueInicial() = 26
	
	override method defensaInicial() = 36
	
	override method vidaMaximaInicial() = 200
	
	override method dropsPosiblesIniciales() = [
		new Garra(cantidad = 2),
		new Garra(cantidad = 3),
		new Cuero(cantidad = 2),
		new Cuero(cantidad = 3),
		new Pluma(cantidad = 2),
		new Pluma(cantidad = 3),
		new Cuerda(cantidad = 2),
		new Cuerda(cantidad = 3),
		new HierbaVerde(cantidad = 1),
		new BotasViejas()
	]
	
	override method nombre() = "Zombie1"
	
	override method experienciaQueDa() = 1
}

class ZombieTipo2 inherits Enemigo {
	override method armaInicial() = new GarraZombie(usuario = self)
	
	override method ataqueInicial() = 21
	
	override method defensaInicial() = 28
	
	override method vidaMaximaInicial() = 120
	
	override method resurreccionesIniciales() = if (probabilidad.en100De(30)) {
		[new ResurrecionZombie()]
	} else {
		new List()
	}
	
	override method dropsPosiblesIniciales() = [
		new Garra(cantidad = 2),
		new Garra(cantidad = 3),
		new Cuero(cantidad = 2),
		new Cuero(cantidad = 3),
		new Pluma(cantidad = 2),
		new Pluma(cantidad = 3),
		new Cuerda(cantidad = 2),
		new Cuerda(cantidad = 3),
		new HierbaVerde(cantidad = 1)
	]
	
	override method nombre() = "Zombie2"
	
	override method experienciaQueDa() = 1
}

class ZombieGordo inherits Enemigo {
	override method armaInicial() = new GarraZombieCegadora(usuario = self)
	
	override method ataqueInicial() = 36
	
	override method defensaInicial() = 60
	
	override method vidaMaximaInicial() = 300
	
	override method dropsPosiblesIniciales() = [
		new Pluma(cantidad = 2),
		new Pluma(cantidad = 3),
		new Cuerda(cantidad = 2),
		new Cuerda(cantidad = 3),
		new Diamante(cantidad = 1)
	]
	
	override method nombre() = "ZombieGordo"
	
	method explotar() {
		escenario.sobrevivientes().filter(
			{ sobreviviente => position.distance(sobreviviente.position()) <= 4 }
		).forEach(
			{ sobreviviente =>
				sobreviviente.sufrirDanio(3 * ataque, self)
				return sobreviviente.cegar(3)
			}
		)
	}
	
	override method efectoAlMorir(asesino) {
		self.explotar()
	}
	
	override method experienciaQueDa() = 2
}

class ZombieTanque inherits Enemigo {
	override method armaInicial() = new GarraZombieRobaVida(usuario = self)
	
	override method ataqueInicial() = 54
	
	override method defensaInicial() = 120
	
	override method vidaMaximaInicial() = 500
	
	override method dropsPosiblesIniciales() = [
		new Cuero(cantidad = 3),
		new Cuero(cantidad = 4),
		new Garra(cantidad = 3),
		new Garra(cantidad = 4),
		new Diamante(cantidad = 1)
	]
	
	override method nombre() = if (self.vidaActual() > self.porcentajeDeVidaMaxima(
	                           		50
	                           	)) "ZombieTanque"
	                           else "ZombieTanqueEnsangrentado"
	
	override method experienciaQueDa() = 3
}