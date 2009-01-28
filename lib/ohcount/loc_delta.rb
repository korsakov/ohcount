module Ohcount
	# Tracks change to lines of code, comments, and blanks for a single language
	class LocDelta
		attr_accessor :language, :code_added, :code_removed, :comments_added, :comments_removed, :blanks_added, :blanks_removed

		def initialize(params={})
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
	end
end

