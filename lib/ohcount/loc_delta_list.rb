module Ohcount
	# Tracks changes to lines of code, comments, and blanks for multiple languages
	class LocDeltaList
		attr_accessor :loc_deltas

		def initialize(loc_deltas=[])
			@loc_deltas = loc_deltas
		end

		def loc_delta(language)
			@loc_deltas.find { |loc_delta| loc_delta.language == language }
		end

		def languages
			@loc_deltas.collect { |loc_delta| loc_delta.language }
		end

		def +(addend)
			case addend
			when LocDelta
				add_loc_delta(addend)
			when LocDeltaList
				add_loc_delta_list(addend)
			else
				raise ArgumentError.new
			end
		end

		def add_loc_delta(addend)
			existing = loc_delta(addend.language)
			if existing
				existing += addend
			else
				@loc_deltas << addend
			end
			self
		end

		def add_loc_delta_list(addend)
			addend.loc_deltas.each do |loc_delta|
				add_loc_delta(loc_delta)
			end
			self
		end

		def code_added
			@loc_deltas.inject(0) { |sum, delta| sum + delta.code_added }
		end

		def code_removed
			@loc_deltas.inject(0) { |sum, delta| sum + delta.code_removed }
		end

		def comments_added
			@loc_deltas.inject(0) { |sum, delta| sum + delta.comments_added }
		end

		def comments_removed
			@loc_deltas.inject(0) { |sum, delta| sum + delta.comments_removed }
		end

		def blanks_added
			@loc_deltas.inject(0) { |sum, delta| sum + delta.blanks_added }
		end

		def blanks_removed
			@loc_deltas.inject(0) { |sum, delta| sum + delta.blanks_removed }
		end

		def net_code
			@loc_deltas.inject(0) { |sum, delta| sum + delta.net_code }
		end

		def net_comments
			@loc_deltas.inject(0) { |sum, delta| sum + delta.net_comments }
		end

		def net_blanks
			@loc_deltas.inject(0) { |sum, delta| sum + delta.net_blanks }
		end

		def net_total
			@loc_deltas.inject(0) { |sum, delta| sum + delta.net_total }
		end

		# Returns a new LocDeltaList excluding all languages that have no changes
		def compact
			LocDeltaList.new(@loc_deltas.reject { |delta| !delta.changed? })
		end

		def ==(b)
			return false unless b
			return false unless languages == b.languages

			self.languages.each do |l|
				return false unless self.loc_delta(l) == b.loc_delta(l)
			end
			true
		end

	end
end
