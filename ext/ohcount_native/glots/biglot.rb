require 'polyglot'

module Ohcount
	# Generic "two languages" polyglot
	class Biglot < Polyglot

		# A Biglot is defined by its name, the first language, the second language, and an array of transitions
		# Each transition is specified as an array of parameters to initialize a StitchTransition
		def initialize(name, lang1, lang2, states, trans)
			@name = name

			@states = (lang1.all_states rescue lang1.states) + (lang2.all_states rescue lang2.states)
			@extra_states = []

			@transitions = (lang1.all_transitions rescue lang1.transitions) + (lang2.all_transitions rescue lang2.transitions)
			@extra_transitions = []

			states.each { |ar| @extra_states << State.new(*ar) }
			trans.each { |ar| @extra_transitions << StitchTransition.new(*ar) }
		end
	end
end
