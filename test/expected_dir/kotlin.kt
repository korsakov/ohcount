kotlin	comment	// Line comment
kotlin	code	fun sum(a : Double, b : Double) : Double { 
kotlin	code	  return a + b 
kotlin	code	}
kotlin	blank	
kotlin	comment	/*
kotlin	comment	 * Block comment
kotlin	comment	 */
kotlin	blank	
kotlin	code	fun hello(place : String) : Unit {
kotlin	code	    print("Hello, \"$place\"\n")
kotlin	code	}
kotlin	blank	
kotlin	comment	/*
kotlin	comment	 * /*
kotlin	comment	 *  * Block comments nest
kotlin	comment	 *  */
kotlin	comment	 */
kotlin	blank	
kotlin	code	fun main() : Unit {
kotlin	code	    hello("""Very, very, very
kotlin	code	             // long place
kotlin	code	             somewhere""")
kotlin	code	}
