require 'polyglot'

module Ohcount
	class RhtmlPolyglot < Polyglot

		def initialize(name, html, ruby)
			@name = name

			@states = html.all_states + ruby.states
			@extra_states = []

			@transitions = html.all_transitions + ruby.transitions
			@extra_transitions = []

			# stitch phplanguage
			@extra_transitions << StitchTransition.new("<%", :html_markup, :ruby_code, :from, false, name)
			@extra_transitions << StitchTransition.new("<%", :html_comment, :ruby_code, :from, false, name)
			@extra_transitions << StitchTransition.new("<%", :html_squote, :ruby_code, :from, false, name)
			@extra_transitions << StitchTransition.new("<%", :html_dquote, :ruby_code, :from, false, name)
			@extra_transitions << StitchTransition.new("%>", :ruby_code, :return, :to, false, name)
		end
	end
end
