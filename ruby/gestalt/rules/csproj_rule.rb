require 'rexml/document'
module Ohcount
	module Gestalt
		class CsprojRule < FileRule

			attr_accessor :import

			def initialize(*args)
				@import = args.shift || /.*/
				@import = /^#{Regexp.escape(@import.to_s)}$/ unless @import.is_a? Regexp

				super(args)
			end

      def process_source_file(source_file)
        if source_file.filename =~ /\.csproj$/ && source_file.language_breakdown('xml')
					callback = lambda do |import|
						@count += 1 if import =~ @import
					end

					begin
          	REXML::Document.parse_stream(source_file.language_breakdown('xml').code, CsprojListener.new(callback))
					rescue REXML::ParseException
						# Malformed XML! -- ignore and move on
					end
        end
      end

		end
	end
end
