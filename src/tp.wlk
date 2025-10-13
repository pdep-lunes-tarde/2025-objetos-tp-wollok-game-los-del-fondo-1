import juego.*
import wollok.game.*

object juegoEscape{
    const intervaloDeTiempoInicial = 50000 // 50 segundos
    var intervaloDeTiempo = intervaloDeTiempoInicial

    method intervaloDeTiempo() = intervaloDeTiempo
    method restar_1s() {
        intervaloDeTiempo = intervaloDeTiempo - 1000
        }
    method tiempoRestante() = intervaloDeTiempo

    method ancho() = 20
    method alto() =  20
    
    method configurar() {
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)
        game.addVisual(pj)
        game.addVisual(temporizador)
        game.addVisual(bandera)
        game.addVisual(mapa)


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

    method iniciar(){
        self.configurar()
        game.start()
    }

    method restart() {
        intervaloDeTiempo = intervaloDeTiempoInicial
        game.clear()
        self.configurar()
    }

    method perder(){
        game.clear()
        game.removeTickEvent("temporizador")
        game.addVisual(perdedor)
        keyboard.enter().onPressDo { self.restart() }
    }

    method ganador(){
        game.removeTickEvent("temporizador")
        game.addVisual(ganador)
        keyboard.enter().onPressDo { self.restart() }
    }
    
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

    method position() = game.at(game.width() - 5, game.height() - 1)
    method text() = "tiempo restante: " + juegoEscape.tiempoRestante() + " ms"
    
    method actualizar() {
        if(juegoEscape.intervaloDeTiempo() != 0){
            juegoEscape.restar_1s() 
        }else{
            juegoEscape.perder()
        }
    }
}



object pj {
    var position = new Position(x=10, y=10)

    method image() = "pj.png"
    method position() = position
    method subi() {
    position = position.up(1)
    }
    method baja() {
    position = position.down(1)
    }
    method derecha() {
    position = position.right(1)
    }
    method izquierda() {
    position = position.left(1)
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

object mapa {
    var property position = game.center()
    method text() = ""

    method chocasteConPj(pj) {
    }
}