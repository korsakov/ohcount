class Ohcount::Parser
	# Parses a file, and store the results in files on disk.
	#
	# This method primarily exists for the benefit of the Ohloh analysis engine,
	# which prefers to store interim results in files on disk. It is unlikely to be
	# useful to the general public.
	#
	# A subdirectory is created for each language found in the target file.
	# Within each language subdirectory, separate files are created for code, comments, and blanks.
	#
	# The 'code' file contains code lines, the 'comments' file contains comment lines, and the 'blanks'
	# file contains a count of the number of blank lines in the file.
	def self.parse_to_dir(args)
		arg_keys = [
			:dir,       # directory to parse to
			:buffer,    # buffer contents of the what we're parsing
			:polyglot   # the polyglot name of what we're parsing
		]
		raise ArgumentError.new('Missing required args') unless (arg_keys - args.keys).empty?

		polyglot = args[:polyglot].to_s
		dir = args[:dir]
		buffer = args[:buffer].to_s

		language_breakdowns = Ohcount::parse(buffer, polyglot)
		language_breakdowns.each do |lb|
			lb_dest_dir = dir + "/" + lb.name
			Dir.mkdir(lb_dest_dir)
			if (lb.code)
				File.open(lb_dest_dir + "/code", "w") do |io|
					code = lb.code
					io.write code
					io.write "\n" unless (code.size == 0 || code[-1,1] == "\n")
				end
			end
			if (lb.comment)
				File.open(lb_dest_dir + "/comment", "w") do  |io|
					comment = lb.comment
					io.write comment
					io.write "\n" unless (comment.size == 0 || comment[-1,1] == "\n")
				end
			end
			File.open(lb_dest_dir + "/blanks", "w") do |io|
				io.write lb.blanks.to_s
			end
		end
	end
end
