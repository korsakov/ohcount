module Ohcount
	module Gestalt
		# rule based a the name of the file
		class FilenameRule < FileRule
			attr_reader :filenames

			def initialize(*args)
				options = args.pop if args.last.is_a?(Hash)
				@filenames = args
				super(options)
			end

			def process_source_file(source_file)
				@count += 1 if regex.match(source_file.filepath)
			end

			def regex
				@regex ||= begin
					r = filenames.collect { |f| "(" + f + ")"}.join("|")
					Regexp.new(r)
				end
			end
		end
	end
end
