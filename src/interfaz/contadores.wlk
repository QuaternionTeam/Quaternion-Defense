import escenario.*

class CasillaNumerica {
	var property objetoConNumero
	const property comportamientoDeCero
	var property position = game.origin()
	
	method nombreDeArchivo()
	
	method image() = ("assets/Interfaz/Digitos/" + self.nombreDeArchivo()) + ".png"
	
	method obtenerNumeroComoString() = objetoConNumero.numeroAMostrar().truncate(
		0
	).toString()
}

object noMostrarCero {
	method anteriorCeroSiNoEsCero() = "_"
	
	method anteriorCeroSiEsCero() = "_"
	
	method ultimoCero() = "_"
}

object mostrarUltimoCero {
	method anteriorCeroSiNoEsCero() = "_"
	
	method anteriorCeroSiEsCero() = "_"
	
	method ultimoCero() = "0"
}

object mostrarTodosLosCerosSiNoEsCero {
	method anteriorCeroSiNoEsCero() = "0"
	
	method anteriorCeroSiEsCero() = "_"
	
	method ultimoCero() = "_"
} /******************** DosDigitos ********************/

class NumeroDosDigitos inherits CasillaNumerica {
	method obtenerNumeroProcesado() {
		const numeroComoString = self.obtenerNumeroComoString()
		
		if (numeroComoString.length() == 1) {
			if (numeroComoString == "0") {
				return comportamientoDeCero.anteriorCeroSiEsCero() + comportamientoDeCero.ultimoCero()
			} else {
				return comportamientoDeCero.anteriorCeroSiNoEsCero() + numeroComoString
			}
		} else {
			return numeroComoString
		}
	}
}

class DosDigitos_Unidad inherits NumeroDosDigitos {
	override method nombreDeArchivo() = "2/_" + self.obtenerNumeroProcesado().charAt(
		1
	)
}

class DosDigitos_Decena inherits NumeroDosDigitos {
	override method nombreDeArchivo() = ("2/" + self.obtenerNumeroProcesado().charAt(
		0
	)) + "_"
} /******************** TresDigitos ********************/

class NumeroTresDigitos inherits CasillaNumerica {
	method obtenerNumeroProcesado() {
		const numeroComoString = self.obtenerNumeroComoString()
		
		if (numeroComoString.length() == 1) {
			if (numeroComoString == "0") {
				return (comportamientoDeCero.anteriorCeroSiEsCero() + comportamientoDeCero.anteriorCeroSiEsCero()) + comportamientoDeCero.ultimoCero()
			} else {
				return (comportamientoDeCero.anteriorCeroSiNoEsCero() + comportamientoDeCero.anteriorCeroSiNoEsCero()) + numeroComoString
			}
		} else {
			if (numeroComoString.length() == 2) {
				return comportamientoDeCero.anteriorCeroSiNoEsCero() + numeroComoString
			} else {
				return numeroComoString
			}
		}
	}
}

class TresDigitos_Unidad inherits NumeroTresDigitos {
	override method nombreDeArchivo() = "3/__" + self.obtenerNumeroProcesado().charAt(
		2
	)
}

class TresDigitos_Decena inherits NumeroTresDigitos {
	override method nombreDeArchivo() = ("3/_" + self.obtenerNumeroProcesado().charAt(
		1
	)) + "_"
}

class TresDigitos_Centena inherits NumeroTresDigitos {
	override method nombreDeArchivo() = ("3/" + self.obtenerNumeroProcesado().charAt(
		0
	)) + "__"
}