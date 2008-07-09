module Ohcount

	def self.diff_files(old_filename, new_filename)
		langs = {}
		ScratchDir.new do |old_dir|
			ScratchDir.new do |new_dir|
				old_buffer = File.new(old_filename).read
				old_polyglot = Ohcount::Detector.detect(SimpleFileContext.new(old_filename))
				Ohcount::Parser.parse_to_dir(:dir => old_dir,
																		:buffer => old_buffer,
																		:polyglot => old_polyglot)
				new_buffer = File.new(new_filename).read
				new_polyglot = Ohcount::Detector.detect(SimpleFileContext.new(new_filename))
				Ohcount::Parser.parse_to_dir(:dir => new_dir,
																		:buffer => new_buffer,
																		:polyglot => new_polyglot)
				langs = diff_sloc_dirs(old_dir, new_dir)
			end
		end
		langs
	end

	protected

	def self.blank_diffs(new_file, old_file)
		# blanks are stored as a simple string
		old_blanks = new_blanks = 0
		if old_file != "/dev/null" && FileTest.file?(old_file)
			File.open(old_file) do |io|
			old_blanks = io.read.to_i
			end
		end
		if new_file != "/dev/null" && FileTest.file?(new_file)
			File.open(new_file) do |io|
			new_blanks = io.read.to_i
			end
		end
		blanks_changed = new_blanks - old_blanks
		blanks_added = blanks_changed > 0 ? blanks_changed : 0
		blanks_removed = blanks_changed < 0 ? -blanks_changed : 0
		[blanks_added, blanks_removed]
	end


	def self.get_langs(dir)
		return {} if dir.nil?
		langs = {}
		Dir.foreach(dir) do |l|
			next unless File.directory?(dir + "/" + l)
			next if [".", ".."].include?(l)
			langs[l] ||= {}
			Dir.foreach(dir + "/" + l) do |s|
				next if [".", ".."].include?(s)
				langs[l][s] = nil
			end
		end
		langs
	end

	def self.diff_sloc_dirs(old_dir, new_dir)
		# figure out the superset of all languages and semantics we're dealing with (on old and new)
		langs = {}
		langs.merge!(get_langs(old_dir))
		langs.merge!(get_langs(new_dir))

		# now go through each and tally up the added/removed
		sloc_infos = []
		langs.each do |lang, semantics|
      next if lang == "_file" # this is a special case...
			sloc_info = SlocInfo.new(lang)

			semantics.each_key do |s|
				old_file = old_dir ? File.join(old_dir, lang, s) : '/dev/null'
				new_file = new_dir ? File.join(new_dir, lang, s) : '/dev/null'
				if s == 'blanks'
					sloc_info.blanks_added, sloc_info.blanks_removed = blank_diffs(new_file, old_file)
				else
					added_removed = diff_file(old_file, new_file)
					case s
					when 'code'
						sloc_info.code_added, sloc_info.code_removed = added_removed
					when 'comment'
						sloc_info.comments_added, sloc_info.comments_removed = added_removed
					else
						raise RuntimeError.new("unknown semantic: #{ s }")
					end
				end
			end
			sloc_infos << sloc_info unless sloc_info.empty?
		end

		# sort them -- nice thing to do
		sloc_infos.sort do |a,b|
			a.language <=> b.language
		end
	end

	def self.diff_file(old, new)
		added = removed = 0

		if FileTest.file?(old) == false
			# original file doesn't exist -> return all new lines as added
			added = `cat '#{ new }' | wc -l`.strip.to_i
		elsif FileTest.file?(new) == false
			# new file doesn't exist -> return all old lines as deleted
			removed = `cat '#{ old }' | wc -l`.strip.to_i
		else
			cmd = "diff -d --normal --suppress-common-lines --new-file '#{old}' '#{new}' | grep '^>' | wc -l"
			added = `#{cmd}`.to_i
			cmd = "diff -d --normal --suppress-common-lines --new-file '#{old}' '#{new}' | grep '^<' | wc -l"
			removed = `#{cmd}`.to_i
		end
		[added, removed]
	end
end
