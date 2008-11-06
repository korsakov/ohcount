module Ohcount

	# Use a SourceFileList to collect information about multiple files. Example:
	#
	#  # find out the number of Ruby lines of code in project 'foo'
	#  sfl = SourceFileList.new(:dir => '/foo')
	#  sfl.language_stats(:ruby).code
	#
	class SourceFileList < Array
		attr_reader :language_facts, :gestalt_facts

		# pass an array of filenames you want to process.
		#
		# Options:
		#
		# :paths directory name from which to populate all files from (deep).
		# :files exact files to analyze
		#
		def initialize(options = {})
			files = options.inject([]) do |memo,(k,v)|
				memo + case k
					when :path then files_from_paths([v])
					when :paths then files_from_paths(v)
					when :files then v
					else raise(ArgumentError, "Unrecognized option: #{ k }")
				end
			end
			super(files)
		end

		def files_from_paths(paths)
			paths.inject([]) do |files, path|
				glob_path = File.join(path,"**","*")
				files + Dir.glob(glob_path)
			end
		end

		#
		# call analyze to generate facts from a collection of files (typically a
		# project directory). Because deducing different facts often requires doing
		# similar work, this function allows multiple facts to be extracted in one
		# single pass
		#
		# *Fact* *Types*
		#
		# :gestalt:: platform dependencies and tools usage
		# :languages:: detailed programming languages facts
		#
		# Examples
		#
		#  sfl = SourceFileList.new(:dir => '/foo/bar')
		#  sfl.analyze(:languages)
		#  puts sfl.ruby.code.count
		#
		#
		def analyze(what = [])
			what = [what] unless what.is_a?(Array)

			do_gestalt   = what.include?(:gestalt)   || what.include?(:*)
			do_languages = what.include?(:language)  || what.include?(:*)

			@language_facts = LanguageFacts.new if do_languages
			@gestalt_facts  = GestaltFacts.new  if do_gestalt

			self.each do |file|
				# we process each file - even if its not a source_code - for
				# library rules sake - they sometimes want 'jar' files or something
				source_file = SourceFile.new(file, :filename => self)
				@language_facts.process(source_file) if do_languages
				@gestalt_facts.process(source_file) if do_gestalt
				yield source_file if block_given?
			end

			@gestalt_facts.post_process if do_gestalt
		end

		def each_source_file
			self.each do |file|
				sf = SourceFile.new(file, :filename => self)
				next unless sf.polyglot
				yield sf
			end
		end

	end
end
