module Ohcount

	# The context provides an abstraction layer between ohcount and the
	# file being analyzed.
	#
	# SimpleFileContext provides ohcount with the target filename and a means
	# to access the contents of the file.
	#
	# In simple usage scenarios, the SimpleFileContext can simply point to an actual
	# file on disk. In more complex scenarios, the context allows the
	# file contents to be delivered to ohcount from a temp file or
	# in-memory cache.
	#
	class SimpleFileContext
		# The original name of the file to be analyzed.
		# This name will be used when detecting the language.
		attr_reader :filename

		# An array of names of other files in the source tree which
		# may be helpful when disambiguating the language used by the target file.
		# For instance, the presence of an Objective-C *.m file is a clue when
		# determining the language used in a *.h header file.
		# This array is optional, but language identification may be less accurate
		# without it.
		attr_reader :filenames

		# The location on disk where the file content can currently be found.
		# This might not be the same as the original name of the file.
		# For example, file content might be stored in temporary directory.
		attr_reader :file_location

		# At a minimum, you must provide the filename.
		#
		# You may also optionally pass an array of names of other files in the source tree.
		# This will assist when disambiguating the language used by the source file.
		# If you do not include this array, language identification may be less accurate.
		#
		# The SimpleFileContext must provide access to the file content. You can do this
		# by one of three means, which will be probed in the following order:
		#
		# 1. You may optionally pass the content of the source file as string +cached_contents+.
		#
		# 2. You may optionally provide +file_location+ as the name of a file on disk
		#    which contains the content of this source file.
		#
		# 3. If you do neither 1 nor 2, then +filename+ will be assumed to be an actual file on
		#    disk which can be read.
		#
		def initialize(filename, filenames = [], cached_contents = nil, file_location = nil)
			@filename = filename
			@filenames = filenames
			@cached_contents = cached_contents
			@file_location = file_location || filename
		end

		# Returns the entire content of the target file as a single string.
		def contents
			return @cached_contents if @cached_contents
			if @file_location
				File.open(file_location) do |f|
					@cached_contents = f.read
				end
			end
			return @cached_contents
		end
	end

end
