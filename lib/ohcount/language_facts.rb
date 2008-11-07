module Ohcount

	# Represents language statistics for a collection of files
	class LanguageFacts
		attr_accessor :fact_map
		attr_accessor :filecount
		attr_accessor :code, :blanks, :comments

		def initialize
			@fact_map = {}
			@filecount = @code = @blanks = @comments = 0
		end

		def process(source_file)
			return unless source_file.source_code?
			source_file.language_breakdowns.each do |lb|
				lang = lb.name
				lang_fact = @fact_map[lang] ||= LanguageFact.new(lang)

				@code += lb.code_count
				@comments += lb.comment_count
				@blanks += lb.blanks

				lang_fact.code += lb.code_count
				lang_fact.comments += lb.comment_count
				lang_fact.blanks += lb.blanks
				lang_fact.filecount += 1
			end
			@filecount += 1
		end

		def method_missing(m, *args)
			@fact_map[m] || @fact_map[m.to_s] || LanguageFact.new(m.to_s)
		end
	end

	# holds stats for an individual language
	class LanguageFact
		attr_reader :language
		attr_accessor :filecount, :blanks, :code, :comments

		def initialize(lang)
			@language = lang
			@filecount = @blanks = @code = @comments = 0
		end
	end
end
