require 'escape_helper'

module Ohcount
	# A Monoglot is a compile-time code generator.
	# It generates C source code which defines the states and transitions
	# required for a single language parser.
	#
	# To create a parser which spans multiple languages, use a Polyglot.
	class Monoglot
		include EscapeHelper

		# The name must be unique
		attr_reader :name

		# A collection of State objects representing possible states
		attr_reader :states

		# The Transition objects defining transitions between states
		attr_reader :transitions

		def initialize(name, states = [], transitions = [])
			@name = name
			@states = states
			@transitions = transitions
		end

		# Emit the generated C code for the state machine definition.
		def print(io)
			Monoglot::print_banner(io, name)
			print_states(io)
			print_transitions(io)
			print_polyglot_def(io)
		end

		def self.print_banner(io, name)
			io.puts ""
			io.puts "/*****************************************************************************"
			left = (80 - name.size)/2
			io.write " "*left
			io.puts name
			io.puts "*****************************************************************************/"
		end

		def definition
		"#{ @name.upcase }_POLYGLOT"
		end
		protected

		def print_states(io)
			#define each
			io.puts "/* States */"
			@states.each do |s|
				s.print(io)
			end

			# now define the collection
			io.write "State *#{ name.upcase }_STATES[] = { "
			@states.each do |s|
				io.write "&#{ s.definition }, "
			end
			io.write "NULL };\n"
		end

		def print_transitions(io)
			io.puts "/* Transitions */"
			# print each transition
			@transitions.each do |t|
				t.print(io)
			end

			#aggregate the transitions
			io.write  "Transition *#{ name.upcase }_TRANSITIONS[] = {"
			@transitions.each do |t|
				io.write " &#{ t.definition },"
			end
			io.write " NULL};\n"
		end

		def print_polyglot_def(io)
			io.puts <<LANG_DEF
Polyglot #{ definition } = {
	"#{ @name.downcase }",
			#{ @name.upcase }_STATES,
			#{ @name.upcase }_TRANSITIONS,
	NULL
};
LANG_DEF
		end

	end
end
