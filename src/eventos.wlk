import wollok.game.*

class ListaDeEventos
{
	const property eventos = new List()
	
	method agregarEvento(evento)
	{
		eventos.add(evento)
	}
	
	method agregarEventos(_eventos)
	{
		_eventos.forEach{ evento => eventos.add(evento) }
	}
	
	method removerEvento(evento)
	{
		eventos.remove(evento)
	}
	
	method removerEventos(_eventos)
	{
		_eventos.forEach{ evento => eventos.remove(evento) }
	}
	
	method avanzarTiempo(segundos)
	{
		eventos.forEach{ evento => evento.avanzarTiempo(segundos) }
	}
	
	method ejecutarEventos()
	{
		eventos.forEach{ evento => evento.ejecutar() }	
	}
}

object eventos02Segundos inherits ListaDeEventos {}
object eventos1Segundo inherits ListaDeEventos {}

class Evento
{
	const property lista
	const property accion
	
	method comenzar()
	{
		lista.agregarEvento(self)
	}
	method interrumpir()
	{
		lista.removerEvento(self)
		self.reiniciar()
	}
	method ejecutar() {	accion.apply() }
	
	method reiniciar()
}

class EventoSimple inherits Evento
{
	var property demora
	var property momento = demora
	
	override method ejecutar()
	{
		self.interrumpir()
		accion.apply()
	}
	
	method avanzarTiempo(segundos)
	{
		momento = 0.max(momento - segundos)
		if (momento == 0) {
			momento = demora
			self.ejecutar()
		}
	}
	
	override method reiniciar() { momento = demora }
	
	method modificarDemora(segundos)
	{
		demora = demora + segundos
		momento = momento + segundos
	}
}

class EventoPeriodico inherits Evento
{
	var property periodo
	var property momento = periodo
	
	method avanzarTiempo(segundos)
	{
		momento = 0.max(momento - segundos)
		
		if(momento == 0)
		{
			momento = periodo
			self.ejecutar()	
		}
	}
	
	override method reiniciar() { momento = periodo }
	
	method aumentarPeriodo(segundos)
	{
		periodo = periodo + segundos
		momento = momento + segundos
	}
}

class EventoPeriodicoTemporal
{
	const property lista
	const property duracion
	const property periodo = 1
	const property accion
	const property accionAlTerminar = {}
	const property eventoPeriodico = new EventoPeriodico(lista = lista, periodo = periodo, accion = accion)
	const property eventoSimple = new EventoSimple(lista = lista, demora = duracion, accion = {
		eventoPeriodico.interrumpir()
		accionAlTerminar.apply()
	})
	
	method avanzarTiempo(segundos)
	{
		eventoPeriodico.avanzarTiempo(segundos)
		eventoSimple.avanzarTiempo(segundos)
	}
	
	method comenzar()
	{
		eventoPeriodico.comenzar()
		eventoSimple.comenzar()	
	}
	
	method interrumpir()
	{
		eventoPeriodico.interrumpir()
		eventoSimple.interrumpir()
	}
	
	method reiniciar()
	{
		eventoPeriodico.reiniciar()
		eventoSimple.reiniciar()
	}
	
	method ejecutar()
	{
		eventoSimple.ejecutar()	
	}
	
	method modificarDuracion(segundos)
	{
		eventoSimple.modificarDemora(segundos)
	}
	
	method momento() = eventoSimple.momento()
	method momentoDePeriodo() = eventoPeriodico.momento()
	
}
