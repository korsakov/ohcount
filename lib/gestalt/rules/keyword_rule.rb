module Ohcount
	module Gestalt
		class KeywordRule < FileRule
			attr_reader :keywords, :language

			def initialize(language, *args)
				options = args.pop if args.last.is_a?(Hash)
				keywords = args
				@language = language
				@keywords = keywords
				super(options)
			end

			def trigger_file?(source_file)
				return unless source_file.language_breakdown(language)
				regexp.match(source_file.language_breakdown(language).code)
			end

			def regexp
				@regexp ||= begin
					Regexp.new("(" + keywords.join("|") + ")")
				end
			end
		end
	end
end
