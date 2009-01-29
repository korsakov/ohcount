module Ohcount
	# Tracks change to lines of code, comments, and blanks for a single language
	class LocDelta
		attr_accessor :language, :code_added, :code_removed, :comments_added, :comments_removed, :blanks_added, :blanks_removed

		def initialize(language, params={})
			raise ArgumentError.new("language can't be nil") unless language
			@language = language
			@code_added = @code_removed = @comments_added = @comments_removed = @blanks_added = @blanks_removed = 0
			params.each { |k,v| send(k.to_s + '=', v) if respond_to?(k.to_s + '=') }
		end		

		def net_code
			@code_added - @code_removed
		end

		def net_comments
			@comments_added - @comments_removed
		end

		def net_blanks
			@blanks_added - @blanks_removed
		end

		def net_total
			net_code + net_comments + net_blanks
		end

		def +(addend)
			raise ArgumentError.new("Cannot add language '#{addend.language}' to language '#{language}'") unless addend.language == language
			@code_added += addend.code_added
			@code_removed += addend.code_removed
			@comments_added += addend.comments_added
			@comments_removed += addend.comments_removed
			@blanks_added += addend.blanks_added
			@blanks_removed += addend.blanks_removed
			self
		end

		def changed?
			code_added != 0 || code_removed != 0 || comments_added != 0 || comments_removed != 0 || blanks_added != 0 || blanks_removed != 0
		end

		def ==(b)
			if (b)
				@language         == b.language &&
					@code_added       == b.code_added &&
					@code_removed     == b.code_removed &&
					@comments_added   == b.comments_added &&
					@comments_removed == b.comments_removed &&
					@blanks_added     == b.blanks_added &&
					@blanks_removed   == b.blanks_removed
			end
		end

	end
end

