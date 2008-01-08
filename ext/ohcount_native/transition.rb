module Ohcount
	# Defines a transition between one parser State and another.
	#
	# A state transition is triggered when a regular expression or "token" match
	# is found in the source code.
	#
	# The Transition class handles transitions between states in a single language. To
	# define transitions between two different languages, use the StitchTransition class.
	class Transition
		# This transition defines state changes within this language only.
		attr_reader :language

		# A regular expression which triggers the state transition when it is matched.
		attr_reader :token

		# This transition can only be followed when we are in the 'from' state.
		attr_reader :from

		# The state we will transition to when the token is matched.
		attr_reader :to

		# One of :from, :to, or :neither.
		#
		# This determines which state 'owns' the text of the token.
		#
		# For instance, a double-quote character in the source code might trigger
		# a transition from a code state to a string state.
		# The who_eats value dictates whether the double-quote character itself
		# should be considered part of the code or part of the string.
		attr_reader :who_eats

		# Set to true if this transition should be ignored -- that is, continue
		# on without changing state, and do not notify any listeners that a state
		# transition occured.
		#
		# Why would we ever want this?
		# One example use is handling escaped string chars in the CMonoglot.
		# When we are in the string state, we want to ignore all escaped double-quotes (\")
		# since these should not return us to the code state. We do this by swallowing the
		# entire \" token with a fake transition and remaining in the string state.
		# Without this fake transition, the \ would be considered an ordinary part of the
		# string and the " would incorrectly return us to the code state.
		attr_reader :fake

		# Each transition needs a unique name. The default name is generated
		# by combining the language name with the names of the 'from' state and the 'to' state.
		# In the case that this is not unique, you may provide an additional string here
		# that will be appended to the generated name.
		attr_reader :name_extension

		def initialize(language, token, from, to, who_eats, fake, name_extension = "")
			@language = language
			@token = token
			@from = from.to_s
			@to = to
			@who_eats = who_eats
			@fake = fake
			@name_extension = name_extension.to_s.upcase
		end

		def definition
		"#{ language.upcase }_#{ from.to_s.upcase }__#{ to.to_s.upcase }#{ name_extension == "" ? "" : "_" + name_extension }".upcase
		end

		def token_eater
			case @who_eats
			when :from
				'FromEatsToken'
			when :to
				'ToEatsToken'
			when :neither
				'NeitherEatsToken'
			else
				raise 'UnknownWhoEats'
			end
		end

		# Emit the transition as a C code definition in the generated source file.
		def print(io)
			full_from = from == :return ? "RETURN" : "&#{ language }_#{ from }".upcase
			full_to = to == :return ? "RETURN" : "&#{ language }_#{ to }".upcase
			io.puts %(Transition #{ definition } = { "#{ token }", #{ full_from }, #{ full_to }, #{ self.token_eater }, #{ fake } };)
		end
	end

	# Represents a transition from a state in one Monoglot to a state in another Monoglot.
	class StitchTransition < Transition
		def initialize(token, from, to, who_eats, fake, polyglot_name)
			@token = token
			@from = from.to_s
			@to = to
			@who_eats = who_eats
			@fake = fake
			@polyglot_name = polyglot_name
		end

		def definition
			"#{ @polyglot_name.upcase }_#{ @from.to_s.upcase }__#{ @to.to_s.upcase }"
		end

		def print(io)
			full_from = @from == :return ? "RETURN" : "&#{ @from }".upcase
			full_to = @to == :return ? "RETURN" : "&#{ @to }".upcase
			io.puts %(Transition #{ definition } = { "#{ @token }", #{ full_from }, #{ full_to }, #{ self.token_eater }, #{ @fake } };)
		end
	end
end
