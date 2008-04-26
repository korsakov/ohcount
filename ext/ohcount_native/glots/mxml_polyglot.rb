require 'polyglot'

module Ohcount
	class MxmlPolyglot < Polyglot

		def initialize(name, actionscript, css)
			mxml = XmlMonoglot.new("mxml")

			@name = name

			@states = actionscript.states + css.states
			@extra_states = mxml.states

			@transitions = actionscript.transitions + css.transitions
			@extra_transitions = mxml.transitions

			# stitch css
			@extra_transitions << StitchTransition.new("<mx:Style>", :mxml_markup, :css_code, :from, false, name)
			@extra_transitions << StitchTransition.new("</mx:Style>", :css_code, :return, :to, false, name)
			@extra_transitions << StitchTransition.new("<mx:Script>", :mxml_markup, :actionscript_code, :from, false, name)
			@extra_transitions << StitchTransition.new("</mx:Script>", :actionscript_code, :return, :to, false, name)
		end
	end
end