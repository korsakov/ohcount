module Ohcount
	module Gestalt
		class CKeywordRule < KeywordRule

			def initialize(*keywords)
				super('c',*keywords)
			end

      def process_source_file(source_file)
        if source_file.language_breakdown('c')
          @count += source_file.language_breakdown('c').code.scan(regexp).size
        elsif source_file.language_breakdown('cpp')
          @count += source_file.language_breakdown('cpp').code.scan(regexp).size
        end
      end
		end
	end
end
