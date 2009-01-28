module Ohcount
	module Gestalt
		# Triggers if a c or cpp header is present
		class JavaImportRule < FileRule
			attr_reader :imports

			def initialize(*args)
				options = args.pop if args.last.is_a?(Hash)
				@imports = args
				super(options)
			end

			def trigger_file?(source_file)
				return false unless source_file.polyglot == 'java'
				regexp.match(source_file.language_breakdown('java').code)
			end

			def regexp
				@regexp ||= begin
					imports_term = "(" + imports.join("|") + ")"
					Regexp.new("import\s+#{ imports_term }")
				end
			end
		end
	end
end
