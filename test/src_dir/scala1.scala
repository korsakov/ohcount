import scala.actors.Actor

case object Ping
case object Pong
case object Stop

/**
 * Ping class
 */
class Ping(count: int, pong: Actor) extends Actor {
  def act() {
    var pingsLeft = count - 1
    pong ! Ping
    while (true) {
      receive {
        case Pong =>
          if (pingsLeft % 1000 == 0)
            Console.println("Ping: pong")
          if (pingsLeft > 0) {
            pong ! Ping
            pingsLeft -= 1
          } else {
            Console.println("Ping: stop")
            pong ! Stop
            exit()
          }
      }
    }
  }
}

/**
 * Pong class
 */
class Pong extends Actor {
  def act() {
    var pongCount = 0
    while (true) {
      receive {
        //pong back the ping
        case Ping =>
          if (pongCount % 1000 == 0)
            Console.println("Pong: ping "+pongCount)
          sender ! Pong
          pongCount = pongCount + 1
        //stop ping ponging
        case Stop =>
          Console.println("Pong: stop")
          exit()
      }
    }
  }
}

/*
 * And this is the main application, playing a game of ping pong
 */
object PingPong extends Application {
  val pong = new Pong
  val ping = new Ping(100000, pong)
  ping.start
  pong.start
}
