require 'rexml/document'
module Ohcount
	module Gestalt
		class MavenRule < FileRule

			attr_accessor :group, :artifact, :type

			# Type is either 'dependency' or 'plugin'
			def initialize(*args)
				@type = args.shift

				@group = args.shift
				@group = /^#{Regexp.escape(@group.to_s)}$/ unless @group.is_a? Regexp

				@artifact = args.shift || /.*/
				@artifact = /^#{Regexp.escape(@artifact.to_s)}$/ unless @artifact.is_a? Regexp

				super(args)
			end

      def process_source_file(source_file)
				callback = lambda do |type, group, artifact|
					if type == @type and group =~ @group and artifact =~ @artifact
						@count += 1
					end
				end

        if source_file.filename =~ /\bpom\.xml$/ && source_file.language_breakdown('xml')
					begin
          	REXML::Document.parse_stream(source_file.language_breakdown('xml').code, MavenListener.new(callback))
					rescue REXML::ParseException
						# Malformed XML! -- ignore and move on
					end
        end
      end

		end
	end
end
