require 'monoglot'

module Ohcount
	class XmlMonoglot < Monoglot
		def initialize(language)
			@name = language
			@states = [
				State.new(language, :markup,  :code),
				State.new(language, :squote,  :code),
				State.new(language, :dquote,  :code),
				State.new(language, :cdata,   :code),
				State.new(language, :comment, :comment)
			]
			@transitions = [
				Transition.new(language, "'",                 :markup,  :squote,  :from,    false),
				Transition.new(language, "'",                 :squote,  :return,  :to,      false),
				Transition.new(language, '\"',                :markup,  :dquote,  :from,    false),
				Transition.new(language, '\"',                :dquote,  :return,  :to,      false),
				Transition.new(language, '<!\\\\[CDATA\\\\[', :markup,  :cdata,   :from,    false),
				Transition.new(language, '\\\\]\\\\]>',       :cdata,   :return,  :to,      false),
				Transition.new(language, '<!--',              :markup,  :comment, :to,      false),
				Transition.new(language, '-->',               :comment, :return,  :from,    false)
			]
		end
	end
end
