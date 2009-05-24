module Ohcount
	module Gestalt
		# an abstract base class representing a rule based
		# on an individual file's attribute (like
		# code content, or filename, etc..)
		class FileRule < Rule
			attr_reader :min_count, :count

			def initialize(args = {})
				args ||= {}
				@min_count = 1
        @count = 0
        @triggers = []
				args.each do |k,v|
					case k
					when :min then @min_count = v
					else raise ArgumentError.new("Unrecognized option: #{ k.inspect }")
					end
				end
				FileRule.add_instance(self)
			end

      # default implementation - will yield a single trigger if appropriate
			def triggers(gestalt_engine)
        if triggered?
          [Trigger.new]
        else
          []
        end
      end

			def self.process_source_file(source_file)
				instances.each do |rule|
          next if rule.triggered?
          rule.process_source_file(source_file)
        end
			end

			def self.instances
				@instances ||= []
			end

			def self.add_instance(r)
				instances << r
			end

      def triggered?
        @count >= @min_count
      end

		end
	end
end
