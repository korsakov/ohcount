module Ohcount
	module Gestalt
		class CKeywordRule < KeywordRule

			def initialize(*keywords)
				super('c',*keywords)
			end

			def trigger_file?(source_file)
				return false unless ['c','cpp'].include?(source_file.polyglot)
				regexp.match(source_file.language_breakdown('c').code) ||
					regexp.match(source_file.language_breakdown('cpp').code)
			end
		end
	end
end
