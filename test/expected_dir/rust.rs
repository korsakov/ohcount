rust	comment	/*
rust	comment	 * This is the example given by www.rust-lang.org
rust	comment	 */
rust	comment	// Line comments work too
rust	code	fn main() {
rust	code	    let nums = [1, 2];
rust	code	    let noms = ["Tim", "Eston", "Aaron", "Ben"];
rust	blank	
rust	code	    let mut odds = nums.iter().map(|&x| x * 2 - 1);
rust	blank	
rust	code	    for num in odds {
rust	code	        do spawn {
rust	code	            println!("{:s} says hello from a lightweight thread!", noms[num]);
rust	code	        }
rust	code	    }
rust	code	}
