require 'monoglot'

module Ohcount
	# A Polyglot is a compile-time code generator.
	# It generates C code which defines the states and transitions
	# required for a complex parser which can span multiple languages.
	#
	# For instance, an HTML file supports not just simple HTML, but also
	# allows embedded spans of Javascript and CSS. HTML files are
	# parsed by Ohcount::HtmlPolyglot, which handles transitions between
	# individual Monoglots for HTML, Javascript, and CSS.
	#
	class Polyglot < Monoglot
		# Transitions above and beyond those defined in the child Monoglots.
		# These are transitions which move us from a state in one Monoglot to
		# a state in another Monoglot.
		attr_reader :extra_transitions

		# The Polyglot may require additional states beyond those defined in the
		# child Monoglots. Those extra states are defined here.
		attr_reader :extra_states

		def print_states(io)
			#define each
			io.puts "/* States */"
			@extra_states.each do |s|
				s.print(io)
			end

			# now define the collection
			io.write "State *#{ name.upcase }_STATES[] = { "
			all_states.each do |s|
				io.write "&#{ s.definition }, "
			end
			io.write "NULL };\n"
		end

		def all_states
			@extra_states + @states
		end

		def all_transitions
			@extra_transitions + @transitions
		end

		def print_transitions(io)
			io.puts "/* Transitions */"
			# print each transition
			@extra_transitions.each do |t|
				t.print(io)
			end

			#aggregate the transitions
			io.write  "Transition *#{ name.upcase }_TRANSITIONS[] = {"
			all_transitions.each do |t|
				io.write " &#{ t.definition },"
			end
			io.write " NULL};\n"
		end
	end
end
