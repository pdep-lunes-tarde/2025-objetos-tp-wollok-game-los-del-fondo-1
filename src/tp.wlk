import juego.*
import wollok.game.*

class Nivel{
    var property position = new Position(x=1, y=1)
    method configurar(){
        game.clear()
        game.addVisual(pj)
        game.addVisual(temporizador)
        game.addVisual(bandera)
        game.addVisual(self)
        self.dibujar_laberinto()

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
}

object nivel1 inherits Nivel{
    method text() = "NIVEL 1"

    override method dibujar_laberinto(){
            new Range(start = 2, end = 10).forEach({ x => game.addVisual(new Pared(position = game.at(x, 1)))})    
    }
}

object nivel2 inherits Nivel{
    method text() = "NIVEL 2"

    override method dibujar_laberinto(){

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
        keyboard.num1().onPressDo({nivel1.configurar()})
        keyboard.num2().onPressDo({nivel2.configurar()})
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
}

object pj {
    var property position = new Position(x=10, y=10)
    var property posicionAnterior = position

    method image() = "pj.png"

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
    var property position = new Position(x=1, y=18)

    method chocasteConPj(pj) {
      game.removeVisual(self)
      juegoEscape.ganador()
    }
}

