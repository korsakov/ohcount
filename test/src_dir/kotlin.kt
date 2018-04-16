// Line comment
fun sum(a : Double, b : Double) : Double { 
  return a + b 
}

/*
 * Block comment
 */

fun hello(place : String) : Unit {
    print("Hello, \"$place\"\n")
}

/*
 * /*
 *  * Block comments nest
 *  */
 */

fun main() : Unit {
    hello("""Very, very, very
             // long place
             somewhere""")
}
