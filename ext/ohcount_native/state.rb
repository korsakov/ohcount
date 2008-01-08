module Ohcount
	# The source code parser is implemented as a state machine.
	#
	# Each state is associated with a particular language and semantic (:code, :comment, or :blank).
	class State
		# The state name -- any helpful mnemonic, but must be unique within this language.
		attr_reader :name

		# When in this state, we are considered to be reading this language.
		attr_reader :language

		# One of :code, :comment, or :blank.
		attr_reader	:semantic

		def initialize(language, name, semantic)
			raise ArgumentError.new("unknown semantic '#{ semantic }'") unless [:code, :comment, :blank].include?(semantic)

			@language = language
			@name = name.to_s.downcase
			@semantic = semantic
		end

		def full_name
		"#{ language }_#{ name.to_s }".upcase
		end

		def definition
			full_name.upcase
		end

		# Emit the state definition as C statements into the generated file.
		def print(io)
			io.puts %(State #{ definition } = { "#{ full_name }", "#{ @language }", semantic_#{ semantic.to_s } };)
		end
	end
end
