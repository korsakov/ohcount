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

      def process_source_file(source_file)
				return unless ['c','cpp'].include?(source_file.polyglot)

        ['c','cpp'].each do |lang|
          next unless source_file.language_breakdown(lang)
          md = regexp.match(source_file.language_breakdown(lang).code)
          @count += (md && md.size).to_i
        end
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
