require 'polyglot'

module Ohcount
	class HtmlPolyglot < Polyglot

		def initialize(name, javascript, css)
			html = XmlMonoglot.new("html")

			@name = name

			@states = javascript.states + css.states
			@extra_states = html.states

			@transitions = javascript.transitions + css.transitions
			@extra_transitions = html.transitions

			# stitch css
			@extra_transitions << StitchTransition.new("<(?i)style(?-i)[^>]*(?i)css(?-i)[^>]*>", :html_markup, :css_code, :from, false, name)
			@extra_transitions << StitchTransition.new("</(?i)style(?-i)>", :css_code, :return, :to, false, name)
			@extra_transitions << StitchTransition.new("<(?i)script(?-i)\\\\ [^>]*(?i)javascript(?-i)[^>]*>", :html_markup, :javascript_code, :from, false, name)
			@extra_transitions << StitchTransition.new("</(?i)script(?-i)>", :javascript_code, :return, :to, false, name)
		end
	end
end
