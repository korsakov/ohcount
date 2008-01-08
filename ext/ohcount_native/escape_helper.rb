module EscapeHelper
	# From Ruby, we are generating C code which will call pcre.
	#
	# This means that characters that are significant to the C parser or the pcre regular
	# expression parser must be escaped multiple times, once for each layer of code that
	# must evaluate it.
	#
	# For instance, suppose you want to represent a literal backslash in a regular expression.
	# That means we must pass TWO backslashes (\\) to pcre.
	# The two backslashes will be stored in a C string constant -- and to express two backslashes
	# in a C string constant, we must use FOUR backslashes (\\\\).
	# It gets even better. To express these four backslashes in Ruby, we must use a literal string
	# that has EIGHT backslashes!
	#
	# This helper method exists to wade through all of this mess, adding the correct number of
	# backslashes to many types of special characters.
	#
	# Some examples:
	#
	#   e('/*')     -> /\\\*      # * must be escaped because it has meaning to regular expression parser
	#   e('"')      -> \\\"       # " must be escaped because it has meaning to the C string parser
	#   e('\\')     -> \\\\\\\\   # \ must be multiply escaped because it has meaning to both C and regex
	#
	# If you really want to pass a regular expression operator to pcre (for instance, you want . to be
	# the wildcard operator, not a literal period), then you should NOT use this helper, and you'll have to
	# sort out your escaping on your own.
	#
	# Someday we'll move this whole product over to Regel and get rid of all this craziness.
	def e(string)
		string.gsub(/\\/,'\\\\' * 4).gsub(/([\+\-\?\.\*\(\)\[\]])/, '\\\\' * 2 + '\1').gsub('"', '\\\\"')
	end
end
