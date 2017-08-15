ruby	code	require 'foo'
ruby	blank	
ruby	comment	#comment
ruby	comment	 #comment
ruby	comment	  #comment with "string"
ruby	blank	
ruby	code	module Foo
ruby	code		class Bar #comment
ruby	code			def foo
ruby	code				"double_quoted string"
ruby	code				"embedded double_quote \""
ruby	code				more_code = true
ruby	code				'single_quoted string'
ruby	code				'embedded single_quote\''
ruby	code				more_code = true
ruby	code				"multiline dquote
ruby	code				more quote
ruby	code				# not a comment
ruby	code				"
ruby	code			end
ruby	code		end
ruby	code	end
