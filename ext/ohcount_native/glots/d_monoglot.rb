require 'monoglot'

module Ohcount
	# D is very similar to C, but not quite.
	#    It allows ` as a string delimiter.
	#    It allows nested block comments using /+ +/.
	class DMonoglot < Monoglot

		def initialize(language)
			@name = language

			# spit out states
			@states = [
				State.new(language, :code, :code),
				State.new(language, :dquote_string, :code),
				State.new(language, :squote_string, :code),
				State.new(language, :backtick_string, :code),
				State.new(language, :line_comment, :comment),
				State.new(language, :block_comment, :comment),
				State.new(language, :nested_comment, :comment)
			]

			@transitions = []

			# line comments
			@transitions << Transition.new(language, '//', :code, :line_comment, :to, false)
			@transitions << Transition.new(language, '\n', :line_comment, :return, :from, false)

			# C-like block comments
			@transitions << Transition.new(language, e('/*'), :code, :block_comment, :to, false)
			@transitions << Transition.new(language, e('/*'), :nested_comment, :block_comment, :to, false)
			@transitions << Transition.new(language, e('*/'), :block_comment, :return, :from, false)

			# Nested block comments
			@transitions << Transition.new(language, e('/+'), :code, :nested_comment, :to, false)
			@transitions << Transition.new(language, e('/+'), :nested_comment, :nested_comment, :to, false)
			@transitions << Transition.new(language, e('+/'), :nested_comment, :return, :from, false)

			# single_quote
			@transitions << Transition.new(language, "'", :code, :squote_string, :to, false)
			@transitions << Transition.new(language, e("\\\\"), :squote_string, :squote_string, :from, true, "ESC_SLASH")
			@transitions << Transition.new(language, e("\\'"), :squote_string, :squote_string, :from, true, "ESC")
			@transitions << Transition.new(language, "'", :squote_string, :return, :from, false)

			# backtick
			@transitions << Transition.new(language, "`", :code, :backtick_string, :to, false)
			@transitions << Transition.new(language, e("\\\\"), :backtick_string, :backtick_string, :from, true, "ESC_SLASH")
			@transitions << Transition.new(language, e("\\`"), :backtick_string, :backtick_string, :from, true, "ESC")
			@transitions << Transition.new(language, "`", :backtick_string, :return, :from, false)

			# double_quote
			@transitions << Transition.new(language, e('"'), :code, :dquote_string, :to, false)
			@transitions << Transition.new(language, e('\\\\'), :dquote_string, :dquote_string, :to, true, "ESC_SLASH")
			@transitions << Transition.new(language, e('\\"'), :dquote_string, :dquote_string, :to, true, "ESC")
			@transitions << Transition.new(language, e('"'), :dquote_string, :return, :from, false)
		end
	end
end
