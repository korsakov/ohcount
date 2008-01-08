require 'foo'

#comment
 #comment
  #comment with "string"

module Foo
	class Bar #comment
		def foo
			"double_quoted string"
			"embedded double_quote \""
			more_code = true
			'single_quoted string'
			'embedded single_quote\''
			more_code = true
			"multiline dquote
			more quote
			# not a comment
			"
		end
	end
end
