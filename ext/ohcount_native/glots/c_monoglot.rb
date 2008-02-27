require 'monoglot'

module Ohcount
	# A generalized Monoglot that can generate the state machine for any C-like language.
	#
	# C-like languages support:
	#   - Single-quoted strings
	#   - Double-quoted strings
	#   - Single-line comments
	#   - Block comments
	#
	# When you instantiate a new CMonoglot, you specify the name of the language and provide
	# regular expressions to define the delimiters for the various string and comment types.
	class CMonoglot < Monoglot

		# Instantiate a new monoglot to generate a C-like language parser. Provide the following:
		#
		# * +language+ - the unique name of the language to be parsed.
		# * +line_comment+ - one or more regular expressions that signify the start of a single-line comment
		# * +block_comment+ - one or more pairs of regular expressions that signify the beginning and end of
		#   a block comment
		# * +double_quote+ - set to true if the language supports double-quote characters to indicate string literals
		# * +single_quote+ - set to true if the language supports single-quote characters to indicate string literals
		# * +options+ - an optional hash of additional options.
		#
		# Options include:
		#
		# * +no_escape_dquote+ - By default, the generated state machine will support \" as an escaped double-quote character
		#   within a double-quoted string literal. To turn off this feature, specify <tt>:no_escape_dquote => true</tt>.
		# * +no_escape_squote+ - Likewise, turns off recognition of support \' as an escaped single-quote character
		#   within a single-quoted string literal.
		#
		def initialize(language, line_comment, block_comment, double_quote = true, single_quote = false, options = {})
			@name = options[:polyglot_name] || language

			# spit out states
			@states = [
				State.new(language, :code, :code),
				State.new(language, :dquote_string, :code),
				State.new(language, :squote_string, :code),
				State.new(language, :line_comment, :comment),
				State.new(language, :block_comment, :comment)
			]

			@transitions = []
			if line_comment
				[ line_comment ].flatten.each_with_index do |line_comment_token, index|
					@transitions << Transition.new(language, line_comment_token, :code, :line_comment, :to, false, index)
				end
				@transitions << Transition.new(language, '\n', :line_comment, :return, :from, false)
			end

			if block_comment && !block_comment.empty?
				block_comment = [ block_comment ] unless block_comment[0].is_a?(Array)
				block_comment.each_with_index do |block_comment_delimiters, index|
					@transitions << Transition.new(language, block_comment_delimiters[0], :code, :block_comment, :to, false, index)
					@transitions << Transition.new(language, block_comment_delimiters[1], :block_comment, :return, :from, false, index)
				end
			end

			if single_quote
				@transitions << Transition.new(language, "'", :code, :squote_string, :to, false)
				unless options[:no_escape_squote]
					@transitions << Transition.new(language, e('\\\\'), :squote_string, :squote_string, :from, true, "ESC_SLASH")
					@transitions << Transition.new(language, e("\\'"), :squote_string, :squote_string, :from, true, "ESC")
				end
				@transitions << Transition.new(language, "'", :squote_string, :return, :from, false)
			end

			if double_quote
				@transitions << Transition.new(language, e('"'), :code, :dquote_string, :to, false)
				unless options[:no_escape_dquote]
					@transitions << Transition.new(language, e('\\\\'), :dquote_string, :dquote_string, :to, true, "ESC_SLASH")
					@transitions << Transition.new(language, e('\\"'), :dquote_string, :dquote_string, :to, true, "ESC")
				end
				@transitions << Transition.new(language, e('"'), :dquote_string, :return, :from, false)
			end
		end

	end
end
