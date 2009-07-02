module Ohcount
	module Gestalt

    # Will yield one trigger per java import - each with the name of the imported
    # namespace. Example java source file:
    #
    # import com.foo.bar;
    #
    # will yield a trigger with name='com.foo.bar'
		class FindJavaImportsRule < FileRule
			attr_reader :keywords, :language

      def initialize(*args)
        @trigger_hash = {}
        super(*args)
      end

			def process_source_file(source_file)
				return unless source_file.language_breakdown('java')

        java_code = source_file.language_breakdown('java').code
        java_code.scan(import_regexp).each do |matches|
          name = matches[0]
          @trigger_hash[name] = @trigger_hash[name].to_i + 1
        end
			end

      # implement deep clone
      def clone
        self.class.new(:min => @min_count)
      end

      def triggers(gestalt_engine)
        triggers = []
        @trigger_hash.each do |k,v|
          triggers << Trigger.new(:name => FindJavaImportsRule.truncate_name(k, 3), :count => v)
        end
        triggers
      end

			def import_regexp
				/^\s*import\s+([a-zA-Z][\w\.\*\-]*)\b/
			end

			# Truncates the java import namespace to a maximum depth.
			# For instance,
			#    truncate_name("com.sun.identity.authentication", 3) => "com.sun.identity"
			def self.truncate_name(s, max_depth)
				s.to_s.split('.')[0, max_depth].join('.')
			end

		end
	end
end
