require 'polyglot'

module Ohcount
	class HtmlWithPhpPolyglot < Polyglot

		def initialize(name, html, phplanguage)
			@name = name

			@states = html.all_states + phplanguage.states
			@extra_states = []

			@transitions = html.all_transitions + phplanguage.transitions
			@extra_transitions = []

			# stitch phplanguage
			@extra_transitions << StitchTransition.new(e("<?"), :html_markup, :php_code, :to, false, name)
			@extra_transitions << StitchTransition.new(e("<?"), :html_comment, :php_code, :to, false, name)
			@extra_transitions << StitchTransition.new(e("<?"), :html_squote, :php_code, :to, false, name)
			@extra_transitions << StitchTransition.new(e("<?"), :html_dquote, :php_code, :to, false, name)
			@extra_transitions << StitchTransition.new(e("?>"), :php_code, :return, :from, false, name)
		end
	end
end
