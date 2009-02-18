module Ohcount
	# Tracks total lines of code, comments, and blanks for multiple languages
	class LocList
		attr_accessor :locs

		def initialize(locs=[])
			@locs = locs
		end

		def loc(language)
			@locs.find { |loc| loc.language == language.to_s }
		end

		def languages
			@locs.collect { |loc| loc.language }
		end

		def +(addend)
			case addend
			when Loc
				add_loc(addend)
			when LocList
				add_loc_list(addend)
			when LocDelta
				add_loc_delta(addend)
			when LocDeltaList
				add_loc_delta_list(addend)
			else
				raise ArgumentError.new
			end
			self
		end

		def add_loc_list(addend)
			addend.locs.each { |loc| add_loc(loc) }
			self
		end

		def add_loc(addend)
			existing = loc(addend.language)
			if existing
				existing += addend
			else
				@locs << addend
			end
			self
		end

		def add_loc_delta(addend)
			l = loc(addend.language)
			unless l
				l = Loc.new(addend.language)
				@locs << l
			end
			l.code += addend.code_added - addend.code_removed
			l.comments += addend.comments_added - addend.comments_removed
			l.blanks += addend.blanks_added - addend.blanks_removed
			self
		end

		def add_loc_delta_list(addend)
			addend.loc_deltas.each { |d| add_loc_delta(d) }
		end

		def code
			@locs.inject(0) { |sum, loc| sum + loc.code }
		end

		def comments
			@locs.inject(0) { |sum, loc| sum + loc.comments }
		end

		def blanks
			@locs.inject(0) { |sum, loc| sum + loc.blanks }
		end

		def total
			@locs.inject(0) { |sum, loc| sum + loc.total }
		end

		def filecount
			@locs.inject(0) { |sum, loc| sum + loc.filecount }
		end

		# Returns a new loc_list excluding all languages with 0 lines
		def compact
			LocList.new(@locs.reject { |loc| loc.total == 0 })
		end

		# Access the individual languages directly
		def method_missing(m, *args)
			loc(m.to_s)
		end
	end
end
