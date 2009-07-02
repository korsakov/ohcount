module Ohcount
	module Gestalt

		# Triggers if a matching java 'import' statement is present
		class JavaImportRule < FileRule

			def initialize(*args)
				options = args.pop if args.last.is_a?(Hash)
				@regex = args[0]
				super(options)
			end

			def process_source_file(source_file)
				return false unless source_file.language_breakdown('java')

        java_code = source_file.language_breakdown('java').code
        java_code.scan(import_regexp).each do |match|
          import = match[0]
          @count += 1 if import =~ @regex
        end
			end

			def import_regexp
				/^\s*import\s+([a-zA-Z][\w\.\*\-]*)\b/
			end
		end
	end
end
