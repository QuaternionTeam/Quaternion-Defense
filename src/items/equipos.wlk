import wollok.game.*
import interfaz.inventarioGeneral.*
import escenario.*
import items.*
import ningunEquipo.*
import objetosEnJuego.imagenEnlazada.*
import personajes.habilidades.*
import eventos.*
import probabilidad.*

/******************** Equipos ********************/
class Equipo inherits Item {
	var property usuario = null
	var estado = desequipado
	
	method estaEquipado() = usuario != null
	
	method defensa()
	
	method equiparEn(_usuario) {
		usuario = _usuario
		estado = equipado
		self.efectoAlEquipar()
		inventarioGeneral.removerItem(self)
	}
	
	method efectoAlEquipar() {
		
	}
	
	method desequipar() {
		self.efectoAlDesequipar()
		usuario = null
		estado = desequipado
		
		inventarioGeneral.agregarItem(self)
	}
	
	method efectoAlDesequipar() {
		
	}
	
	override method interactuar() {
		estado.interactuar(self)
	}
	
	method quitar(cantidadAQuitar) {
		estado.quitar(self)
	}
	
	method cantidad() = 1
	
	method reduccionDeDanio() = 0
	
	method recibioAtaque(danio, agresor) {
		
	}
	
	override method agregarAInventario() {
		inventarioGeneral.agregarItem(self)
	}
	
	override method numeroAMostrar() = 0
	
	override method direccion() = super() + "Equipos/"
}

object equipado {
	method interactuar(equipo) {
		equipo.desequipar()
	}
	
	method quitar(equipo) {
		equipo.desequipar()
		inventarioGeneral.removerItem(self)
	}
}

object desequipado {
	method interactuar(equipo) {
		equipo.equiparEn(escenario.sobrevivienteSeleccionado())
	}
	
	method quitar(equipo) {
		inventarioGeneral.removerItem(self)
	}
} /******************** Clase Arma ********************/

class Arma inherits Equipo {
	//Estadisticas del equipo
	method ataque()
	
	method ataquePerforante()
	
	method rangoMinimo()
	
	method rangoMaximo()
	
	// Verifica si una objetivo esta a rango de ataque del equipo
	method estaEnRango(objetivo) {
		var distancia = usuario.position().distance(objetivo.position())
		
		return (self.rangoMinimo() <= distancia) and (distancia <= self.rangoMaximo())
	}
	
	override method equiparEn(_usuario) {
		super(_usuario)
		usuario.arma().desequipar()
		usuario.arma(self)
	}
	
	override method desequipar() {
		usuario.equiparManos()
		super()
	}
	
	method atacoA(danioHecho, objetivo) {
		
	}
	
	method matoA(muerto) {
		
	}
	
	method mato() {
		
	}
	
	override method direccion() = (super() + "Armas/") + self.nombre()
} /********************Armas ********************/

class GarraZombie inherits Arma {
	override method nombre() = "Garra_Zombie"
	
	override method ataque() = 0
	
	override method defensa() = 0
	
	override method ataquePerforante() = 0
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
}

class GarraZombiePerforante inherits GarraZombie {
	override method nombre() = "Garra_Zombie"
	
	override method atacoA(danioHecho, objetivo) {
		if (probabilidad.en100De(20)) objetivo.desangrar(1)
	}
}

class GarraZombieCegadora inherits GarraZombie {
	override method nombre() = "Garra_Zombie_Cegadora"
	
	override method atacoA(danioHecho, objetivo) {
		if (probabilidad.en100De(25)) objetivo.cegar(1)
	}
}

class GarraZombieRobaVida inherits GarraZombie {
	override method nombre() = "Garra_Zombie_Roba_Vida"
	
	override method atacoA(danioHecho, objetivo) {
		usuario.curar(danioHecho * 0.3)
	}
} /******************** Equipos De Mano ********************/

// Con cinco ataques otorga experiencia extra gana experiencia 
class EspadaDeEntrenamiento inherits Arma {
	var nroAtaques = 0
	
	override method nombre() = "Espada_De_Entrenamiento"
	
	override method ataque() = 12
	
	override method ataquePerforante() = 0
	
	override method defensa() = 5
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method atacoA(danioHecho, objetivo) {
		nroAtaques += 1
		if (nroAtaques == 5) {
			usuario.ganarExperiencia(1)
			nroAtaques = 0
		}
	}
} // 50% de probabilidad de infligir sangrado(2)

class Katana inherits Arma {
	override method nombre() = "Katana"
	
	override method ataque() = 35
	
	override method ataquePerforante() = 0
	
	override method defensa() = 25
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method atacoA(danioHecho, objetivo) {
		if (probabilidad.en100De(30)) objetivo.desangrar(2)
	}
} //Aumenta la probabilidad de Evasion y Critico en 10% 

class EspadaCorta inherits Arma {
	override method nombre() = "Espada_Corta"
	
	override method ataque() = 28
	
	override method ataquePerforante() = 0
	
	override method defensa() = 5
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method efectoAlEquipar() {
		usuario.modificarProbabilidadDeEvasion(15)
		usuario.modificarProbabilidadDeCritico(15)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarProbabilidadDeEvasion(-15)
		usuario.modificarProbabilidadDeCritico(-15)
	}
} //Aumenta la probabilidad de Bloqueo en 20%

class EspadaRecta inherits Arma {
	override method nombre() = "Espada_Recta"
	
	override method ataque() = 22
	
	override method ataquePerforante() = 0
	
	override method defensa() = 5
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method efectoAlEquipar() {
		usuario.modificarProbabilidadDeBloqueo(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarProbabilidadDeBloqueo(-20)
	}
}

class Antorcha inherits Arma {
	override method nombre() = "Antorcha"
	
	override method ataque() = 15
	
	override method ataquePerforante() = 0
	
	override method defensa() = 0
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method atacoA(danioHecho, objetivo) {
		objetivo.quemar(3, usuario)
	}
}

class EspadaGrande inherits Arma {
	override method nombre() = "Espada_Grande"
	
	override method ataque() = 37
	
	override method ataquePerforante() = 0
	
	override method defensa() = 10
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
}

class EspadaPerforante inherits Arma {
	const property ataqueBase = 46
	var property ataque = ataqueBase
	var property ataquePerforante = 0
	var numeroDeAtaque = primerAtaque
	
	override method nombre() = "Espada_Perforante"
	
	override method defensa() = 5
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	method numeroDeAtaque(_numeroDeAtaque) {
		numeroDeAtaque = _numeroDeAtaque
	}
	
	override method atacoA(danioHecho, objetivo) {
		// Realiza un ataque potenciado que ignora defensa cada 3er ataque
		numeroDeAtaque.atacoA(self, objetivo)
	}
}

object primerAtaque {
	method atacoA(arma, objetivo) {
		arma.numeroDeAtaque(segundoAtaque)
	}
	
	method pantalonesCortosRecibioAtaque(arma) {
		arma.numeroDeAtaqueRecibido(segundoAtaque)
	}
}

object segundoAtaque {
	method atacoA(arma, objetivo) {
		arma.ataquePerforante(arma.ataqueBase())
		arma.ataque(0)
		arma.numeroDeAtaque(tercerAtaque)
	}
	
	method pantalonesCortosRecibioAtaque(arma) {
		arma.usuario().modificarProbabilidadDeEvasion(100)
		arma.numeroDeAtaqueRecibido(tercerAtaque)
	}
}

object tercerAtaque {
	method atacoA(arma, objetivo) {
		var explosion = new ExplosionPerforante(objetoEnlazado = objetivo)
		game.addVisual(explosion)
		new EventoSimple(
			lista = eventos02Segundos,
			demora = 200,
			accion = { game.removeVisual(explosion) }
		).comenzar()
		
		arma.ataquePerforante(0)
		arma.ataque(arma.ataqueBase())
		arma.numeroDeAtaque(primerAtaque)
	}
	
	method pantalonesCortosRecibioAtaque(arma) {
		arma.usuario().modificarProbabilidadDeEvasion(100)
		arma.numeroDeAtaqueRecibido(primerAtaque)
	}
} // Al recibir daño letal, cura 50% de vida maxima al usuario

class AngelGuardian inherits Arma {
	var resurreccion = null //new Resurreccion(nivel = 5)
	
	override method nombre() = "Angel_Guardian"
	
	override method ataque() = 42
	
	override method ataquePerforante() = 0
	
	override method defensa() = 15
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method numeroAMostrar() = resurreccion.momentoDeEnfriamiento()
	
	override method efectoAlEquipar() {
		resurreccion = new AutoRevivir(usuario = usuario)
		usuario.agregarResurreccion(resurreccion)
	}
	
	override method efectoAlDesequipar() {
		usuario.removerResurreccion(resurreccion)
	}
	
	method estado() = if (resurreccion.momentoDeEnfriamiento() == 0) "Listo"
	                  else "Enfriamiento"
	
	override method image() = ((("assets/Items/Equipos/Armas/" + self.nombre()) + "_") + self.estado()) + ".png"
}

class Arco inherits Arma {
	override method nombre() = "Arco"
	
	override method ataque() = 32
	
	override method ataquePerforante() = 0
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 4
	
	override method defensa() = 0
}

class Manos inherits Arma {
	override method nombre() = "Manos"
	
	override method ataque() = 5
	
	override method ataquePerforante() = 0
	
	override method defensa() = 0
	
	override method rangoMinimo() = 1
	
	override method rangoMaximo() = 1
	
	override method combinar() {
		
	}
	
	override method desequipar() {
		
	}
}

class ManosDeJan inherits Manos {
	override method ataque() = usuario.ataque()
	
	override method ataquePerforante() = 5 + usuario.ataqueExtraManos()
	
	override method mato() {
		usuario.aumentarAtaqueExtraManos()
	}
} /******************** Armaduras ********************/

/******************** Equipo De Mano ********************/
class EquipoDeMano inherits Equipo {
	override method equiparEn(_usuario) {
		super(_usuario)
		usuario.equipoDeMano().desequipar()
		usuario.equipoDeMano(self)
	}
	
	override method desequipar() {
		usuario.equipoDeMano(ningunEquipo)
		super()
	}
	
	override method direccion() = (super() + "EquiposDeMano/") + self.nombre()
}

class EscudoRedondo inherits EquipoDeMano {
	override method nombre() = "Escudo_Redondo"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 25
	
	override method efectoAlEquipar() {
		usuario.modificarProbabilidadDeBloqueo(30)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarProbabilidadDeBloqueo(-30)
	}
}

class AnilloLujoso inherits EquipoDeMano {
	override method nombre() = "Anillo_Lujoso"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 36
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeAtaque(20)
		usuario.modificarMultiplicadorDeDanioRecibido(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeAtaque(-20)
		usuario.modificarMultiplicadorDeDanioRecibido(-20)
	}
}

class BrazaleteDeOro inherits EquipoDeMano {
	override method nombre() = "Brazalete_De_Oro"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 20
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(15)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(-15)
	}
} /******************** Cascos ********************/

class Casco inherits Equipo {
	override method equiparEn(_usuario) {
		super(_usuario)
		usuario.casco().desequipar()
		usuario.casco(self)
	}
	
	override method desequipar() {
		usuario.casco(ningunEquipo)
		super()
	}
	
	override method image() = ("assets/Items/Equipos/Cascos/" + self.nombre()) + ".png"
}

class CascoTest inherits Casco {
	override method nombre() = "Casco_Test"
	
	override method defensa() = 35
}

class CollarDeOro inherits Casco {
	override method nombre() = "Collar_De_Oro"
	
	override method reduccionDeDanio() = 1
	
	override method defensa() = 12
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(15)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(-15)
	}
}

class CollarSalvaje inherits Casco {
	override method nombre() = "Collar_Salvaje"
	
	override method reduccionDeDanio() = 1
	
	override method defensa() = 12
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeAtaque(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeAtaque(-20)
	}
}

class CascoDeCuero inherits Casco {
	override method nombre() = "Casco_De_Cuero"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 24
	
	override method efectoAlEquipar() {
		usuario.modificarVidaMaxima(50)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarVidaMaxima(-50)
	}
}

class CascoDePaladin inherits Casco {
	override method nombre() = "Casco_De_Paladin"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 42
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeDanioRecibido(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeDanioRecibido(-20)
	}
}

class CascoDeGladiador inherits Casco {
	override method nombre() = "Casco_De_Gladiador"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 42
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeAtaque(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeAtaque(-20)
	}
} /******************** Pechera ********************/

class Pechera inherits Equipo {
	override method equiparEn(_usuario) {
		super(_usuario)
		usuario.pechera().desequipar()
		usuario.pechera(self)
	}
	
	override method desequipar() {
		usuario.pechera(ningunEquipo)
		super()
	}
	
	override method direccion() = (super() + "Pecheras/") + self.nombre()
}

class PecheraTest inherits Pechera {
	override method nombre() = "Pechera_Test"
	
	override method defensa() = 2
}

class CamisaVerde inherits Pechera {
	override method nombre() = "Camisa_Verde"
	
	override method reduccionDeDanio() = 1
	
	override method defensa() = 10
	
	override method efectoAlEquipar() {
		usuario.modificarProbabilidadDeEvasion(10)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarProbabilidadDeEvasion(-10)
	}
}

class CamisaAzul inherits Pechera {
	override method nombre() = "Camisa_Azul"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 26
}

class ArmaduraLigeraDeCuero inherits Pechera {
	override method nombre() = "Armadura_Ligera_De_Cuero"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 26
	
	override method efectoAlEquipar() {
		usuario.modificarProbabilidadDeEvasion(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarProbabilidadDeEvasion(-20)
	}
}

class ArmaduraLigeraDeHierro inherits Pechera {
	override method nombre() = "Armadura_Ligera_De_Hierro"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 41
	
	override method efectoAlEquipar() {
		usuario.modificarProbabilidadDeEvasion(10)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarProbabilidadDeEvasion(-10)
	}
}

class ArmaduraPesada inherits Pechera {
	override method nombre() = "Armadura_Pesada"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 55
	
	override method recibioAtaque(danio, agresor) {
		agresor.sufrirDanio(danio * 0.25, usuario)
	}
}

class ArmaduraDePaladin inherits Pechera {
	override method nombre() = "Armadura_De_Paladin"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 55
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(20)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(-20)
	}
}

class AlasDeAngel inherits Pechera {
	const regeneracion = new EventoPeriodico(
		lista = eventos1Segundo,
		periodo = 5,
		accion = { usuario.curar(usuario.porcentajeDeVidaMaxima(5)) }
	)
	
	override method nombre() = "Alas_De_Angel"
	
	override method reduccionDeDanio() = 1
	
	override method defensa() = 12
	
	override method efectoAlEquipar() {
		regeneracion.comenzar()
	}
	
	override method efectoAlDesequipar() {
		regeneracion.terminar()
	}
} /******************** Pantalones ********************/

class Pantalones inherits Equipo {
	override method equiparEn(_usuario) {
		super(_usuario)
		usuario.pantalones().desequipar()
		usuario.pantalones(self)
	}
	
	override method desequipar() {
		usuario.pantalones(ningunEquipo)
		
		super()
	}
	
	override method direccion() = (super() + "Pantalones/") + self.nombre()
}

class PantalonesTest inherits Pantalones {
	override method nombre() = "Pantalones_Test"
	
	override method defensa() = 2
}

class Calzoncillos inherits Pantalones {
	override method nombre() = "Calzoncillos"
	
	override method reduccionDeDanio() = 1
	
	override method defensa() = 5
}

class PantalonesLargos inherits Pantalones {
	override method nombre() = "Pantalones_Largos"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 32
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(15)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(-15)
	}
}

class PantalonesCortos inherits Pantalones {
	var numeroDeAtaqueRecibido = primerAtaque
	
	method numeroDeAtaqueRecibido(nroDeAtaque) {
		numeroDeAtaqueRecibido = nroDeAtaque
	}
	
	override method nombre() = "Pantalones_Cortos"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 32
	
	override method recibioAtaque(danio, agresor) {
		numeroDeAtaqueRecibido.pantalonesCortosRecibioAtaque(danio, agresor)
	}
} /******************** Botas ********************/

class Botas inherits Equipo {
	override method equiparEn(_usuario) {
		super(_usuario)
		usuario.botas().desequipar()
		usuario.botas(self)
	}
	
	override method desequipar() {
		usuario.botas(ningunEquipo)
		super()
	}
	
	override method direccion() = (super() + "Botas/") + self.nombre()
}

class BotasTest inherits Botas {
	override method nombre() = "Botas_Test"
	
	override method defensa() = 2
}

class BotasViejas inherits Botas {
	override method nombre() = "Botas_Viejas"
	
	override method reduccionDeDanio() = 1
	
	override method defensa() = 12
}

class BotasDeCuero inherits Botas {
	override method nombre() = "Botas_De_Cuero"
	
	override method reduccionDeDanio() = 2
	
	override method defensa() = 24
	
	override method efectoAlEquipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(15)
	}
	
	override method efectoAlDesequipar() {
		usuario.modificarMultiplicadorDeVidaMaxima(-15)
	}
}

class BotasDeHierro inherits Botas {
	override method nombre() = "Pantalones_Largos"
	
	override method reduccionDeDanio() = 3
	
	override method defensa() = 36
}