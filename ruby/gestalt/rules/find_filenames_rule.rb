module Ohcount
	module Gestalt

    # will yield as many triggers as files that match the regexp
		class FindFilenamesRule < FileRule
			attr_reader :regex

			def initialize(regex, options = {})
				@regex = regex
        @triggers = []
        @name_from_match = options.delete(:name_from_match).to_i
				super(options)
			end

      # deep clone
      def clone
        self.class.new(@regex,:name_from_match => @name_from_match)
      end

      def triggers(gestalt_engine)
        @triggers
      end

			def process_source_file(source_file)
        m = @regex.match(source_file.filename)
        if m
          @triggers << Trigger.new(:name => m[@name_from_match])
        end
			end

		end
	end
end
