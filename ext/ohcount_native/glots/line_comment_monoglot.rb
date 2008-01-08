require 'monoglot'

module Ohcount
	class LineCommentMonoglot < Monoglot

		def initialize(language, line_comment_tokens)
			@name = language

			@states = [
				State.new(language, :code, :code),
				State.new(language, :comment, :comment)
			]

			@transitions = []
			[ line_comment_tokens ].flatten.each_with_index do |token, index|
				@transitions << Transition.new(language, token, :code, :comment, :to, false, index.to_s)
			end
			@transitions << Transition.new(language, '\n', :comment, :return, :from, false)
		end
	end
end
