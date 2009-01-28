module Ohcount
	require 'diff/lcs'

	# SourceFile abstracts a source code file and allows easy querying of ohcount-related
	# information.
	#
	# It provides some abstractions to enable ohloh to call it in its own, weird, way.
	# For example, in simple usage scenarios, the SimpleFileContext can simply point
	# to an actual file on disk. In more complex scenarios, the context allows the
	# file contents to be delivered to ohcount from a temp file or in-memory cache.
	#
	class SourceFile
		# The filename we're dealing with.
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
		def initialize(filename, options = {})
			@filename      = filename
			@filenames     = options[:filenames] || []
			@contents      = options[:contents]
			@file_location = options[:file_location]
		end

		def contents
			@contents ||= File.open(@file_location || @filename) do |io|
				io.read
			end
		end

		# A bit complicated because a nil value can either mean that we haven't checked,
		# or that we have checked but received a nil result.
		def polyglot
			return @polyglot if defined?(@polyglot)
			@polyglot = Ohcount::Detector.detect(self) if file?
		end

		# returns true iff we represent a file (could be a dir)
		def file?
			File.exist?(@filename) && File.file?(@filename) ||
				@file_location && File.exist?(@file_location) && File.file?(@file_location) ||
				@contents
		end

		def basename
			File.basename(filename)
		end

		def parse(&block)
			@language_breakdowns = polyglot ? Ohcount::parse(contents, polyglot, &block) : []
		end

		def language_breakdowns
			@language_breakdowns ||= parse
		end

		def language_breakdown(language)
			language_breakdowns.find { |lb| lb.name == language.to_s } || LanguageBreakdown.new(language.to_s)
		end

		def clone_and_rename(new_name)
			attributes = {
				:filenames     => filenames,
				:contents      => contents,
				:file_location => file_location || filename
			}
			Ohcount::SourceFile.new(new_name, attributes)
		end

		# will yield with the current directory set in a way that the filename
		# exists and contains the actual file contents.
		#
		# This is useful to call when a file must absolutely be referenced on disk.
		def realize_file
			raise ArgumentError.new('Missing block?') unless block_given?

			if File.exist?(@filename)
				yield @filename
			elsif @file_location && File.basename(@file_location) == basename
				yield @file_location
			else

				# must recreate a directory and stuff
				ScratchDir.new do |d|
					realized_filename = File.join(d,basename)
					File.open(realized_filename, "w") { |io| io.write(contents) }
					return yield(realized_filename)
				end
			end
		end

		def licenses
			@licenses ||= begin
				comments = ''
				parse do |language, semantic, line|
					next unless semantic == :comment
					# Strip leading punctuation.
					comments << ' ' + $1 if line =~ /^[\s[:punct:]]*(.*?)$/
				end
				LicenseSniffer.sniff(comments)
			end
		end

		def raw_entities(&block)
			polyglot && Ohcount::parse_entities(contents, polyglot, &block)
		end

		# returns the list of languages included in the parsed
		# language_breakdowns
		def languages
			language_breakdowns.collect { |lb| lb.name }
		end

		# returns a collection of sloc_infos containing
		# the diffs from the this current object to the
		# new object
		def diff(new)
			all_languages = (self.languages + new.languages).uniq
			all_languages.collect do |language|
				si = Ohcount::SlocInfo.new(language)
				lb_old = language_breakdown(language)
				lb_new = new.language_breakdown(language)

				#code
				si.code_added, si.code_removed = calc_diff(lb_old.code, lb_new.code)
				si.comments_added, si.comments_removed = calc_diff(lb_old.comment, lb_new.comment)
				si.blanks_added = lb_new.blanks - lb_old.blanks
				si.blanks_removed = lb_old.blanks - lb_new.blanks

				# strip negative blank counts
				si.blanks_added = 0 if si.blanks_added < 0
				si.blanks_removed = 0 if si.blanks_removed < 0

				si
			end.reject do |si|
				# remove meangingless sloc_infos
				si.no_changes?
			end
		end

		# takes 2 strings and returns an array containing the count
		# of added lines and deleted lines. Example
		#
		#   calc_diff("a\nb", "a\nc")      # [1,1] -> one added, one deleted
		#
		def calc_diff(a,b)
			LCSDiff::Diff::LCS.diff(a.split("\n"),b.split("\n")).flatten.inject([0,0]) do |m, change|
				m[0] += 1 if change.adding?
				m[1] += 1 if change.deleting?
				m
			end
		end
	end
end
