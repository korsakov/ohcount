module Ohcount
	module Gestalt
		# Triggers if a c or cpp header is present
		class CHeaderRule < FileRule
			attr_reader :headers

			def initialize(*args)
				options = args.pop if args.last.is_a?(Hash)
				@headers = args
				super(options)
			end

			def trigger_file?(source_file)
				return false unless ['c','cpp'].include?(source_file.polyglot)
				regexp.match(source_file.language_breakdown('c').code) ||
					regexp.match(source_file.language_breakdown('cpp').code)
			end

			def regexp
				@regexp ||= begin
					header_term = "(" + headers.join("|") + ")"
					Regexp.new("include\s+['<\"]#{ header_term }[\">']", Regexp::IGNORECASE)
				end
			end
		end
	end
end
