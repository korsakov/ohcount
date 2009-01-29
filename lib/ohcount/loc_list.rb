module Ohcount
	# Tracks total lines of code, comments, and blanks for multiple languages
	class LocList
		attr_accessor :locs

		def initialize(locs=[])
			@locs = locs
		end

		def loc(language)
			@locs.find { |loc| loc.language == language }
		end

		def languages
			@locs.collect { |loc| loc.language }
		end

		def +(addend)
			case addend
			when LocList
				add_loc_list(addend)
			when Loc
				add_loc(addend)
			else
				raise ArgumentError.new
			end
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

		# Returns a new loc_list excluding all languages with 0 lines
		def compact
			LocList.new(@locs.reject { |loc| loc.total == 0 })
		end
	end
end
