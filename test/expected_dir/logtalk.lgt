logtalk	comment	/* test file for Logtalk parsing */
logtalk	blank	
logtalk	comment	% this is a Logtalk source file
logtalk	blank	
logtalk	code	:- object(hello_world).
logtalk	blank	
logtalk	comment		% the initialization/1 directive argument is automatically executed
logtalk	comment		% when the object is loaded into memory:
logtalk	code		:- initialization((nl, write('********** Hello World! **********'), nl)).
logtalk	blank	
logtalk	code	:- end_object.
