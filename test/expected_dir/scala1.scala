scala	code	import scala.actors.Actor
scala	blank	
scala	code	case object Ping
scala	code	case object Pong
scala	code	case object Stop
scala	blank	
scala	comment	/**
scala	comment	 * Ping class
scala	comment	 */
scala	code	class Ping(count: int, pong: Actor) extends Actor {
scala	code	  def act() {
scala	code	    var pingsLeft = count - 1
scala	code	    pong ! Ping
scala	code	    while (true) {
scala	code	      receive {
scala	code	        case Pong =>
scala	code	          if (pingsLeft % 1000 == 0)
scala	code	            Console.println("Ping: pong")
scala	code	          if (pingsLeft > 0) {
scala	code	            pong ! Ping
scala	code	            pingsLeft -= 1
scala	code	          } else {
scala	code	            Console.println("Ping: stop")
scala	code	            pong ! Stop
scala	code	            exit()
scala	code	          }
scala	code	      }
scala	code	    }
scala	code	  }
scala	code	}
scala	blank	
scala	comment	/**
scala	comment	 * Pong class
scala	comment	 */
scala	code	class Pong extends Actor {
scala	code	  def act() {
scala	code	    var pongCount = 0
scala	code	    while (true) {
scala	code	      receive {
scala	comment	        //pong back the ping
scala	code	        case Ping =>
scala	code	          if (pongCount % 1000 == 0)
scala	code	            Console.println("Pong: ping "+pongCount)
scala	code	          sender ! Pong
scala	code	          pongCount = pongCount + 1
scala	comment	        //stop ping ponging
scala	code	        case Stop =>
scala	code	          Console.println("Pong: stop")
scala	code	          exit()
scala	code	      }
scala	code	    }
scala	code	  }
scala	code	}
scala	blank	
scala	comment	/*
scala	comment	 * And this is the main application, playing a game of ping pong
scala	comment	 */
scala	code	object PingPong extends Application {
scala	code	  val pong = new Pong
scala	code	  val ping = new Ping(100000, pong)
scala	code	  ping.start
scala	code	  pong.start
scala	code	}
