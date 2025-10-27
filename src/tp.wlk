import juego.*
import wollok.game.*

class Nivel{
    var property position = new Position(x=1, y=0)
    method configurar(){
        game.clear()
        pj.reiniciarPosicion()
        game.addVisual(pj)
        game.addVisual(temporizador)
        game.addVisual(bandera)
        game.addVisual(self)
        self.paredesGenerales()
        self.dibujar_laberinto()
        self.dibujar_elementosJuego()
        
        keyboard.w().onPressDo {
            pj.subi()
        }
        keyboard.s().onPressDo {
            pj.baja()
        }
        keyboard.d().onPressDo {
            pj.derecha()
        }
        keyboard.a().onPressDo {
            pj.izquierda()
        }

        // 1000 = 1 segundo   
        game.onTick(1000, "temporizador", { temporizador.actualizar() })
        game.onCollideDo(pj, { otro => otro.chocasteConPj(pj) })
    }

    method dibujar_laberinto()
    method dibujar_elementosJuego()
    method paredesGenerales(){
        new Range(start = 0, end = 20).forEach({ x => game.addVisual(new Pared(position = game.at(x, 1)))})    
        new Range(start = 1, end = 18).forEach({ y => game.addVisual(new Pared(position = game.at(0, y)))})    
        new Range(start = 0, end = 20).forEach({ x => game.addVisual(new Pared(position = game.at(x, 18)))})    
        new Range(start = 1, end = 18).forEach({ y => game.addVisual(new Pared(position = game.at(19, y)))})    
        }
}

object nivel_1 inherits Nivel{
    method text() = "NIVEL 1"
    
    override method dibujar_elementosJuego(){

    const reloj = new Reloj(position = new Position(x=18,y=9))
    game.addVisual(reloj)

    const portal1 = new Portal(position = new Position(x=1,y=7))
    const portal2 = new Portal(position = new Position(x=18,y=17))

    portal1.destino(portal2)
    portal2.destino(portal1)

    game.addVisual(portal1)
    game.addVisual(portal2)
    }

    override method dibujar_laberinto() {
        // Fila 16 
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 10) game.addVisual(new Pared(position = game.at(x, 16)))
        })    

        // Fila 14
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 5 && x != 15) game.addVisual(new Pared(position = game.at(x, 14)))
        })    

        // Fila 12
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 3 && x != 17) game.addVisual(new Pared(position = game.at(x, 12)))
        })    

        // Fila 10
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 8) game.addVisual(new Pared(position = game.at(x, 10)))
        })    

        // Fila 8
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 12) game.addVisual(new Pared(position = game.at(x, 8)))
        })    

        // Fila 6
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 6 && x != 14) game.addVisual(new Pared(position = game.at(x, 6)))
        })    

        // Fila 4
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 10) game.addVisual(new Pared(position = game.at(x, 4)))
        })    
    }
}
    

object nivel_2 inherits Nivel{
    method text() = "NIVEL 2"
        override method dibujar_elementosJuego(){
        const reloj = new Reloj(position = new Position(x=1,y=8) )
        game.addVisual(reloj)
        const portal1 = new Portal(position = new Position(x=18,y=8))
        const portal2 = new Portal(position = new Position(x=1,y=14))

        portal1.destino(portal2)
        portal2.destino(portal1)

        game.addVisual(portal1)
        game.addVisual(portal2)
    }
   override method dibujar_laberinto() {
        // Fila 15
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 5 && x != 10 && x != 15) game.addVisual(new Pared(position = game.at(x, 15)))
        })    

        // Fila 13
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 3 && x != 8 && x != 17) game.addVisual(new Pared(position = game.at(x, 13)))
        })    

        // Fila 11
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 6 && x != 12 && x != 18) game.addVisual(new Pared(position = game.at(x, 11)))
        })    

        // Fila 9
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 4 && x != 10 && x != 15) game.addVisual(new Pared(position = game.at(x, 9)))
        })    

        // Fila 7
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 6 && x != 9 && x != 14 && x != 18) game.addVisual(new Pared(position = game.at(x, 7)))
        })    

        // Fila 5
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 3 && x != 8 && x != 12 && x != 16) game.addVisual(new Pared(position = game.at(x, 5)))
        })    

        // Fila 3 
        new Range(start = 1, end = 19).forEach({ x =>
            if(x != 5 && x != 10 && x != 15) game.addVisual(new Pared(position = game.at(x, 3)))
        })    
    }
}

object juegoEscape{
    method ancho() = 20
    method alto() =  20
    
    method configurar() {
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)
        self.menuInicio()

    }
    method menuInicio(){
        game.addVisual(menuInicio)
        keyboard.num1().onPressDo({nivel_1.configurar()})
        keyboard.num2().onPressDo({nivel_2.configurar()})
    }


    method iniciar(){
        self.configurar()
        game.start()
    }

    method restart() {
        temporizador.tiempoDeJuego(temporizador.tiempoDeJuegoInicial()) 
        game.clear()
        self.configurar()
    }

    method perder(){
        game.clear()
        game.removeTickEvent("temporizador")
        game.addVisual(perdedor)
        keyboard.enter().onPressDo{ self.restart() }
    }

    method ganador(){
        game.clear()
        game.removeTickEvent("temporizador")
        game.addVisual(ganador)
        keyboard.enter().onPressDo{ self.restart() }
    }
    
}

object menuInicio {
    method position() = game.center()
    method text() = "Bienvenido. Elige un nivel: 1.Nivel 1 o 2.Nivel 2"
}

object ganador {
    method position() = game.center()
    method text() = "GANASTE ; presiona enter para volver a jugar"
}

object perdedor {
    method position() = game.center()
    method text() = "PERDISTE ; presiona enter para volver a jugar"
}

object temporizador {
    const tiempoDeJuegoInicial = 10000 // 10 segundos
    var property tiempoDeJuego = tiempoDeJuegoInicial

    method restar_1s() {
        tiempoDeJuego = tiempoDeJuego - 1000
        }
    method tiempoRestante() = tiempoDeJuego
    method tiempoDeJuegoInicial() = tiempoDeJuegoInicial

    method position() = game.at(game.width() - 5, game.height() - 1)
    method text() = "tiempo restante: " + self.tiempoRestante() + " ms"
    
    method actualizar() {
        if(self.tiempoDeJuego() > 0){
            self.restar_1s() 
        }else{
            juegoEscape.perder()
        }
    }
    method duplicarTiempo(){
        tiempoDeJuego = tiempoDeJuego * 2
    }
}

object pj {
    var property position = posicionIncial
    var property posicionAnterior = position
    const posicionIncial = new Position(x=18,y=2)

    method image() = "pj.png"

    method reiniciarPosicion(){
        self.position(posicionIncial)
    }

    method subi() {
        self.actualizarPosicion(position.up(1))
    }

    method baja() {
        self.actualizarPosicion(position.down(1))
    }

    method derecha() {
        self.actualizarPosicion(position.right(1))
    }

    method izquierda() {
        self.actualizarPosicion(position.left(1))
    }

    method actualizarPosicion(nuevaPosicion) {
        posicionAnterior = position
        position = nuevaPosicion
    }

    method posicionAnterior() = posicionAnterior
}

class Pared {
    method image() = "pared.png"
    var property position

    method chocasteConPj(pj) {
        pj.position(pj.posicionAnterior())
    }
}

object bandera {
    method image() = "bandera.png"
    var property position = new Position(x=1, y=17)

    method chocasteConPj(pj) {
      game.removeVisual(self)
      juegoEscape.ganador()
    }
}

class Reloj{
    method image() = "reloj.png"
    var property position

    method chocasteConPj(pj) {
      game.removeVisual(self)
      temporizador.duplicarTiempo()
    }
}

class Portal{
    method image() = "portal.png"
    var property position
    var property destino = null

    method chocasteConPj(pj) {
        // game.removeVisual(self)
        pj.actualizarPosicion(destino.position())    
    }
}