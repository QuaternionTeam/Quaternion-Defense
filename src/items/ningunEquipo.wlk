object ningunEquipo {
  method nombre() = "Ningun_Equipo"
  
  method esMismoItem(item) = item.nombre() == self.nombre()
  
  method cantidad() = 1
  
  method numeroAMostrar() = 0
  
  method image() = ""
  
  method direccion() = "Equipos/"
  
  method informacion() = self.direccion()
  
  method defensa() = 0
  
  method reduccionDeDanio() = 0
  
  method estaEquipado() = true
  
  method interactuar() {
    
  }
  
  method equiparEn(usuario) {
    
  }
  
  method desequipar() {
    
  }
  
  method combinar() {
    
  }
  
  method combinarCon(item) {
    
  }
  
  method agregarAInventario() {
    
  }
  
  method quitar(cantidad) {
    
  }
  
  method recibioAtaque(danio, agresor) {
    
  }
  
  method efectoAlEquipar() {
    
  }
  
  method efectoAlDesequipar() {
    
  }
}