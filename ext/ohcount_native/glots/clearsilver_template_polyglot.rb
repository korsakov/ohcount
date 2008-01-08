require 'polyglot'

module Ohcount
	class ClearsilverTemplate < Polyglot

		def initialize(name, html, clearsilver)
			@name = name

			@states = html.all_states + clearsilver.states
			@extra_states = []

			@transitions = html.all_transitions + clearsilver.transitions
			@extra_transitions = []

			# stitch phplanguage
			@extra_transitions << StitchTransition.new(e("<?cs"), :html_markup, :clearsilver_code, :from, false, name)
			@extra_transitions << StitchTransition.new(e("<?cs"), :html_comment, :clearsilver_code, :from, false, name)
			@extra_transitions << StitchTransition.new(e("<?cs"), :html_squote, :clearsilver_code, :from, false, name)
			@extra_transitions << StitchTransition.new(e("<?cs"), :html_dquote, :clearsilver_code, :from, false, name)
			@extra_transitions << StitchTransition.new(e("?>"), :clearsilver_code, :return, :to, false, name)
		end
	end
end
