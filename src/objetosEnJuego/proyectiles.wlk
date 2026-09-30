import wollok.game.*
import objetosEnJuego.*

import eventos.*
import probabilidad.*

class Proyectil inherits ObjetoEnJuego 
{
	const property tirador
	const property direccion = tirador.orientacion()
	var property position = tirador.position()
	const property danio
	const property disparo = new EventoPeriodico(lista = eventos02Segundos, periodo = 0.2, accion = { self.avanzarSiEsPosible() })
	
	method objetivo() = game.colliders(self).last()

	method disparar()
	{
		disparo.comenzar()
		game.addVisual(self)	
	}
	
	method direccionAAvanzar() = direccion.posicion(self.position())
	
	method avanzarSiEsPosible()
	{
		if(tirador.escenario().estaDentro(self.direccionAAvanzar()))
		{
			self.avanzar()
			if(not tirador.escenario().esAtravesable(self.position()))
				self.impactar()
		}
			
		else
			self.desaparecer()
	}
	
	method avanzar() { position = self.direccionAAvanzar()	}
	
	method impactar()
	{
		const objetivo = self.objetivo()
		objetivo.recibirAtaqueDeHabilidad(danio, tirador)
		self.efecto(objetivo, tirador)
	}
	
	method efecto(unObjetivo, unTirador)
	
	method desaparecer()
	{
		game.removeVisual(self)
		disparo.interrumpir()
	}
	
	override method esAtravesable() = true
}

class FlechaSimple inherits Proyectil
{	
	method nombre() = "Flecha_Simple"
	override method efecto(unObjetivo, unTirador) {}
	override method image() = "Proyectiles/" + self.nombre() + "/" + direccion.toString() + ".png"
}

class FlechaIgnea inherits FlechaSimple
{
	override method nombre() = "Flecha_Ignea"
	override method efecto(unObjetivo, unTirador) {	unObjetivo.quemar(unTirador, 3) }
}

class FlechaGelida inherits FlechaSimple
{
	override method nombre() = "Flecha_Gelida"
	override method efecto(unObjetivo, unTirador) { unObjetivo.escarchar(3) }
}

class FlechaOscura inherits FlechaSimple
{
	override method nombre() = "Flecha_Oscura"
	override method efecto(unObjetivo, unTirador) { unObjetivo.cegar(3) }
}

class FlechaPerforante inherits FlechaSimple
{
	override method nombre() = "Flecha_Perforante"
	override method efecto(unObjetivo, unTirador) { unObjetivo.desangrar(3) }
}

/*class GranadaExplosiva inherits Proyectil
{
	constructor(_danio) = super(_danio)
	{
		comportamiento = colisiona
	}
	
	override method impactar(posicion, tirador)
	{
		var objetivosEnRango = (escenario.enemigos() + escenario.sobrevivientes()).filter{ objetivo => posicion.distance(objetivo.position()) <= 1 }
		
		objetivosEnRango.forEach{ _objetivo => _objetivo.recibirAtaqueDeHabilidad(tirador, danio) }
	}
	
	override method image() = "Proyectiles/GranadaExplosiva/" + direccion.toString() + ".png"
}

class BalaDePistola inherits Proyectil
{
	constructor(_danio) = super(_danio)
	{
		comportamiento = colisiona
	}
	
	override method impactar(posicion, tirador) {  posicion.allElements().last().recibirAtaqueDeHabilidad(tirador, danio) }
	
	override method image() = "Proyectiles/BalaDePistola/" + direccion.toString() + ".png"
}*/



