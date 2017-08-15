module Ohcount
	module Gestalt

		# Triggers if a matching C# 'using' library include statement is present
		class CSharpUsingRule < FileRule

			def initialize(*args)
				@regex = args.shift
				super(args)
			end

			def process_source_file(source_file)
				return false unless source_file.language_breakdown('csharp')

        source_file.language_breakdown('csharp').code.scan(using_regexp).each do |match|
          @count += 1 if match[0] =~ @regex
        end
			end

			def using_regexp
				@@using_regexp ||= /^\s*using\s+([a-zA-Z][\w\.\*\-]*)\s*;/
			end
		end
	end
end
