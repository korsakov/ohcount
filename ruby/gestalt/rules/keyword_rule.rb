module Ohcount
	module Gestalt
		# Will trigger if the given keywords are found in the specified language.
		# Example;
		#
		#
		# c_keywords '__MSDOS__', 'MSDOS', :min => 2 
		# 	# this will trigger if the	words "__MSDOS__" or "MSDOS" is found at
		# 	# least twice in 'C' source code
		#
		class KeywordRule < FileRule
			attr_reader :keywords, :language

			def initialize(language, *args)
				options = args.pop if args.last.is_a?(Hash)
				keywords = args
				@language = language
				@keywords = keywords
				super(options)
			end

			def process_source_file(source_file)
				if language
					return unless source_file.language_breakdown(language)
					@count += source_file.language_breakdown(language).code.scan(regexp).size
				else
					# All languages
					source_file.language_breakdowns.each do |lb|
						@count += lb.code.to_s.scan(regexp).size
					end
				end
			end

			def regexp
				@regexp ||= begin
					Regexp.new("(" + keywords.join("|") + ")")
				end
			end
		end
	end
end
