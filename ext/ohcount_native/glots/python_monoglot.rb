require 'monoglot'

module Ohcount
	class PythonMonoglot < Monoglot

		def initialize(language)
			@name = language
			@states = [
				State.new( language, :code, :code),
				State.new( language, :multi_line_squote, :code),
				State.new( language, :multi_line_dquote, :code),
				State.new( language, :raw_dquote, :code),
				State.new( language, :squote, :code),
				State.new( language, :dquote, :code),
				State.new( language, :line_comment, :comment)
			]
			@transitions = [
				Transition.new(language, "'''", :code, :multi_line_squote, :from, false),
				Transition.new(language, "'''",:multi_line_squote, :return, :from, false),
				Transition.new(language, e('"""'), :code, :multi_line_dquote, :from, false),
				Transition.new(language, e('"""'), :multi_line_dquote, :return, :from, false),
				Transition.new(language, e('r"'), :code, :raw_dquote, :from, false),
				Transition.new(language, e('"'), :raw_dquote, :return, :from, false),
				Transition.new(language, "'", :code, :squote, :from, false),
				Transition.new(language, e("\\'"), :squote, :return, :from, true, "ESC"),
				Transition.new(language, "'", :squote, :return, :to, false),
				Transition.new(language, e('"'), :code, :dquote, :to, false),
				Transition.new(language, e('\\"'), :dquote, :return, :from, true, "ESC"),
				Transition.new(language, e('"'), :dquote, :return, :to, false),
				Transition.new(language, '#', :code, :line_comment, :to, false),
				Transition.new(language, '\n', :line_comment, :return, :from, false)
			]
		end
	end
end
