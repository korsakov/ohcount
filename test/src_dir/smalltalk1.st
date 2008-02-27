"======================================================================
|
|   Benchmark for streams
|
|
 ======================================================================"


Eval [
    n := Smalltalk arguments isEmpty
	ifTrue: [ 10000 ]
	ifFalse: [ 1 max: Smalltalk arguments first asInteger ].

    hello := String new writeStream.
    n timesRepeat: [ hello nextPutAll: 'hello
\' ].  "this is a comment
so this line is a comment too\"
    hello position displayNl
"but the previous one, and this one too, are not!" ]
