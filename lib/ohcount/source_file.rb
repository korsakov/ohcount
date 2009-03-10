module Ohcount
	require 'diff/lcs'

	# SourceFile represents a single source code file.
	#
	# It can be a pointer to an actual file on disk, or it may strictly
	# be an in-memory buffer.
	class SourceFile
		# Required. The original name of the file, as it appears in the source tree.
		attr_accessor :filename

		# The location on disk where the file contents can currently be found.
		# This location does not need to match the original filename.
		attr_accessor :file_location

		# An array of names of other files in the source tree which
		# may be helpful when disambiguating the language used by the target file.
		# For instance, the presence of an Objective-C *.m file is a clue when
		# determining the language used in a *.h header file.
		# This array is optional, but language identification may be less accurate
		# without it.
		attr_accessor :filenames

		# If you pass :contents to this initializer, then SourceFile
		# works in memory and does not need to access the file on disk.
		#
		# If you do not pass the :contents, then SourceFile will first check
		# :file_location and then :filename (in that order) to get the file contents.
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

		# Returns true iff we represent a file and not a directory
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

		# Yields a path to a physical file on disk containing the file contents.
		# This is useful when a file absolutely must be referenced on disk.
		# A temporary file will be created if an existing file is not available.
		def realize_file
			raise ArgumentError.new('Missing block?') unless block_given?

			if File.exist?(@filename)
				yield @filename
			elsif @file_location && File.basename(@file_location) == basename
				yield @file_location
			else
				# No existing copy. Create a temporary file.
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
					# Strip leading and trailing punctuation/whitespace.
					comments << ' ' + $1 if line.strip =~ /^[\s[:punct:]]*(.*?)$/
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

		# Returns a LocList reflecting the total lines of code in each language
		def loc_list
			language_breakdowns.inject(LocList.new) do |sum, lb|
				sum + Loc.new(lb.name,
											:code => lb.code_count, 
											:comments => lb.comment_count,
											:blanks => lb.blanks,
											:filecount => 1)
			end
		end

		# Returns a LocDeltaList reflecting the lines changed in all languages
		# when comparing this source file ("before") to a new version ("after")
		def diff(after)
			all_languages = (self.languages + after.languages).uniq.sort

			all_languages.inject(LocDeltaList.new) do |sum, lang|
				sum + calc_loc_delta(lang, after)
			end.compact
		end

		# Returns a LocDelta reflecting the lines changed in a single language
		# when comparing this source file ("before") to a new version ("after")
		def calc_loc_delta(language, after)
			lb_before = self.language_breakdown(language)
			lb_after = after.language_breakdown(language)

			delta = LocDelta.new(language)

			delta.code_added, delta.code_removed = calc_diff(lb_before.code, lb_after.code)
			delta.comments_added, delta.comments_removed = calc_diff(lb_before.comment, lb_after.comment)

			if lb_before.blanks > lb_after.blanks
				delta.blanks_removed = lb_before.blanks - lb_after.blanks
			else
				delta.blanks_added = lb_after.blanks - lb_before.blanks
			end

			delta
		end

		# Takes two strings and returns an array containing the count
		# of added lines and deleted lines. Example:
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
