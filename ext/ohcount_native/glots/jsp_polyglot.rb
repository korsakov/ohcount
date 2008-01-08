require 'polyglot'

module Ohcount
	class JspPolyglot < Polyglot

		def initialize(name, html, java)
			@name = name

			@states = html.all_states + java.states
			@extra_states = []

			@transitions = html.all_transitions + java.transitions
			@extra_transitions = []

			# stitch phplanguage
			@extra_transitions << StitchTransition.new("<%", :html_markup,  :java_code, :from, false, name)
			@extra_transitions << StitchTransition.new("<%", :html_comment, :java_code, :from, false, name)
			@extra_transitions << StitchTransition.new("<%", :html_squote,  :java_code, :from, false, name)
			@extra_transitions << StitchTransition.new("<%", :html_dquote,  :java_code, :from, false, name)
			@extra_transitions << StitchTransition.new("%>", :java_code,    :return,    :to,   false, name)
		end
	end
end
