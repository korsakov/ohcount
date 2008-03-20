require 'monoglot'

# I created a new Monoglot for DCL because it's syntax is a bit different.
# The following lines should be counted as code:
#   $ anything
#   anything
# The following lines should be counted as comment:
#   $! anything
#   $ !anything
# And lines like these should be counted as blank:
#   $
#   $!

module Ohcount
	class DclMonoglot < Monoglot

		def initialize(language)
			@name = language

			@states = [
				State.new(language, :initial, :blank),
				State.new(language, :real_code, :code),
				State.new(language, :line_code, :code),
				State.new(language, :comment, :comment)
			]

			@transitions = []
			@transitions << Transition.new(language, '[$][ \t\r]*[^! \t\r\n]', :initial, :real_code, :to, false)
			@transitions << Transition.new(language, '[$][ \t\r]*[!][ \t\r]*[^ \t\r\n]', :initial, :comment, :to, false)
			@transitions << Transition.new(language, '\n', :comment, :return, :from, false)
			@transitions << Transition.new(language, '\n', :real_code, :return, :from, false)
			@transitions << Transition.new(language, '\n', :line_code, :return, :from, false)
			@transitions << Transition.new(language, '[^$! \t\r\n]', :initial, :line_code, :to, false)

		end
	end
end
