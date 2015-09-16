module Ohcount
	module Gestalt
		class XmlKeywordRule < KeywordRule

			def initialize(*keywords)
				super('xml',*keywords)
			end

			def trigger_file?(source_file)
				return false unless source_file.polyglot = 'xml'
				regexp.match(source_file.language_breakdowns('xml').code)
			end
		end
	end
end
