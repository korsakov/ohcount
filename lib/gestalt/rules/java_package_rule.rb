module Ohcount
	module Gestalt
		# Triggers if the code implements a java package matching the given regex
		class JavaPackageRule < FileRule
			attr_reader :packages

			def initialize(*args)
				options = args.pop if args.last.is_a?(Hash)
				@packages = args
				super(options)
			end

			def trigger_file?(source_file)
				return false unless source_file.polyglot == 'java'
				regexp.match(source_file.language_breakdown('java').code)
			end

			def regexp
				@regexp ||= begin
					packages_term = "(" + packages.join("|") + ")"
					Regexp.new("package\s+#{ packages_term }")
				end
			end
		end
	end
end

