smalltalk	comment	"======================================================================
smalltalk	comment	|
smalltalk	comment	|   Benchmark for streams
smalltalk	comment	|
smalltalk	comment	|
smalltalk	comment	 ======================================================================"
smalltalk	blank	
smalltalk	blank	
smalltalk	code	Eval [
smalltalk	code	    n := Smalltalk arguments isEmpty
smalltalk	code		ifTrue: [ 10000 ]
smalltalk	code		ifFalse: [ 1 max: Smalltalk arguments first asInteger ].
smalltalk	blank	
smalltalk	code	    hello := String new writeStream.
smalltalk	code	    n timesRepeat: [ hello nextPutAll: 'hello
smalltalk	code	\' ].  "this is a comment
smalltalk	comment	so this line is a comment too\"
smalltalk	code	    hello position displayNl
smalltalk	code	"but the previous one, and this one too, are not!" ]
