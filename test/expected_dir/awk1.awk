awk	comment	# prchecks - print formatted checks
awk	comment	#   input:  number \t amount \t payee
awk	comment	#   output: eight lines of text for preprinted check forms
awk	blank	
awk	code	BEGIN {
awk	code	    FS = "\t"
awk	code	    dashes = sp45 = sprintf("%45s", " ")
awk	code	    gsub(/ /, "-", dashes)        # to protect the payee
awk	code	    "date" | getline date         # get today's date
awk	code	    split(date, d, " ")
awk	code	    date = d[2] " " d[3] ", " d[6]
awk	code	    initnum()    # set up tables for number conversion
awk	code	}
awk	code	NF != 3 || $2 >= 1000000 {        # illegal data
awk	code	    printf("\nline %d illegal:\n%s\n\nVOID\nVOID\n\n\n", NR, $0)
awk	code	    next                          # no check printed
awk	code	}
awk	code	{   printf("\n")                  # nothing on line 1
awk	code	    printf("%s%s\n", sp45, $1)    # number, indented 45 spaces
awk	code	    printf("%s%s\n", sp45, date)  # date, indented 45 spaces
awk	code	    amt = sprintf("%.2f", $2)     # formatted amount
awk	code	    printf("Pay to %45.45s   $%s\n", $3 dashes, amt)  # line 4
awk	code	    printf("the sum of %s\n", numtowords(amt))        # line 5
awk	code	    printf("\n\n\n")              # lines 6, 7 and 8
awk	code	}
awk	blank	
awk	code	function numtowords(n,   cents, dols) { # n has 2 decimal places
awk	code	    cents = substr(n, length(n)-1, 2)
awk	code	    dols = substr(n, 1, length(n)-3)
awk	code	    if (dols == 0)
awk	code	        return "zero dollars and " cents " cents exactly"
awk	code	    return intowords(dols) " dollars and " cents " cents exactly"
awk	code	}
awk	blank	
awk	code	function intowords(n) {
awk	code	    n = int(n)
awk	code	    if (n >= 1000)
awk	code	        return intowords(n/1000) " thousand " intowords(n%1000)
awk	code	    if (n >= 100)
awk	code	        return intowords(n/100) " hundred " intowords(n%100)
awk	code	    if (n >= 20)
awk	code	        return tens[int(n/10)] " " intowords(n%10)
awk	code	    return nums[n]
awk	code	}
awk	blank	
awk	code	function initnum() {
awk	code	    split("one two three four five six seven eight nine " \
awk	code	 			prchecks           "ten eleven twelve thirteen fourteen fifteen " \
awk	code	 			prchecks           "sixteen seventeen eighteen nineteen", nums, " ")
awk	code	    split("ten twenty thirty forty fifty sixty " \
awk	code	 	 prchecks           "seventy eighty ninety", tens, " ")
awk	code	}
awk	blank	
