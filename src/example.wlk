class Jugador {
	const personajes = []
	const  items = []
	
	// 2  
	method cantAtrapadas() = personajes.sum{p => p.cantAtrapadas()}
	
	// 3
	method personjeMVP() = personajes.max{ p => p.cantGrandesAtrapadas() }
	
	// 4
	method jugadoresAtrapados(){ 
		const jugadores = #{}
		personajes.forEach{pers=>jugadores.addAll(pers.pequeniasAtrapadas().map{a => a.jugador()})}
	//	return personajes.flatMap{p =>p.pequeniasAtrapadas()}.map{p => p.jugador()}.asSet() // elimina repetidos
	}
	
	method cantidadRecursosValiosos() = items.count{r => r.valor() > 100 }
	
	method atrapasteUnPersonaje(atrapada,personaje){
		items.forEach{r => r.ganarRecursos(atrapada, personaje) }
	}
	method teAtraparonUnPersonaje(atrapada,personaje){
		items.forEach{r => r.perderRecursos(atrapada, personaje) }
	}
	
	method elegirPersonaje(p) { 
		personajes.add(p)
		p.jugador(self)
	}
}

class Personaje {
	var property jugador = null
	const atrapadas = []
	
	method atrapar(personaje, puntos, tiempo) {
		const atrapada = new Atrapada(tiempo = tiempo, puntos = puntos, atrapado = personaje)
		atrapadas.add(atrapada)
		personaje.jugador().teAtraparonUnPersonaje(atrapada, self)
		jugador.atrapasteUnPersonaje(atrapada, self) 
	}
	
	method cantAtrapadas() = atrapadas.size()
	
	method cantGrandesAtrapadas() = atrapadas.count{atrap => atrap.esGrande() }
	
	method pequeniasAtrapadas() = atrapadas.filter{atrap => !atrap.esGrande() }
}

class Atrapada {
	var property tiempo
	var property puntos
	var property atrapado
	
	method esGrande() = puntos > 10
}

// Recursos

class Recurso {
	var property cotizacion
}

class Item {
	var property recurso
	var property cant
	//var property importancia = 1 // para las gemas
	
	method ganarRecursos(atrapada, atrapador) {
		cant = cant + atrapada.puntos() * self.incrementoTiempoExtra(atrapada)
	}
	
	method incrementoTiempoExtra(atrapada) =
		if(atrapada.tiempo()> 100) videoJuego.formulaExtrania(atrapada.tiempo()) else 1

	method perderRecursos(atrapada, personaje)  { }
	
	method valor() = cant * recurso.cotizacion()
}

class ItemPersonalizado inherits Item{
	
	const personajesCompatibles = []
	
	method nuevaCompatibilidad(p){
		personajesCompatibles.add(p)
	}
	
	override method ganarRecursos(atrapada, atrapador) {
		if(personajesCompatibles.contains(atrapador)) 
			self.duplicar()
		else 
			super(atrapada, atrapador)
	}
	method duplicar() { 
		cant *= 2
	}
}	

class ItemGema inherits Item {
	var property importancia 
	
	override method perderRecursos(atrapada, personaje) { 
		cant = cant - atrapada.puntos() * importancia * self.incrementoTiempoExtra(atrapada)
	}
	override method valor() = super() * importancia
}

object videoJuego{
	method formulaExtrania(valor) = valor + 1
}