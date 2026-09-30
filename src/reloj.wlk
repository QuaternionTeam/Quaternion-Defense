import wollok.game.*
import eventos.*
import teclado.*

object reloj
{
	method comenzarEventos()
	{
		game.onTick(200, self.identity().toString() + "_Eventos02", { eventos02Segundos.avanzarTiempo(0.2) })
		game.onTick(1000, self.identity().toString() + "_Eventos1", { eventos1Segundo.avanzarTiempo(1) })
	}
	
	method detenerEventos()
	{
		game.removeTickEvent(self.identity().toString() + "_Eventos02")
		game.removeTickEvent(self.identity().toString() + "_Eventos1")
	}
	
	method activarPausa()
	{
		self.detenerEventos()
		teclado.cambiarEstado(estadoPausado)
		mensajeDePausa.ubicar()		
	}
	method desactivarPausa()
	{
		self.comenzarEventos()
		teclado.cambiarEstado(estadoJugando_Normal)
		mensajeDePausa.quitar()		
	}
}

object mensajeDePausa
{
	method image() = "Interfaz/DatosEnPartida/Pausa.png"
	method position() = game.at(1,1)
	method ubicar()
	{
		game.addVisual(self)
	}
	method quitar()
	{
		game.removeVisual(self)
	}
}