module Ohcount
	# Tracks total lines of code, comments, and blanks for a single language
	class Loc
		attr_accessor :language, :code, :comments, :blanks, :filecount

		def initialize(language, params={})
			raise ArgumentError.new("language can't be nil") unless language
			@language = language
			@code = @comments = @blanks = @filecount = 0
			params.each { |k,v| send(k.to_s + '=', v) if respond_to?(k.to_s + '=') }
		end		

		def total
			@code + @comments + @blanks
		end

		def +(addend)
			raise ArgumentError.new("Cannot add language '#{addend.language}' to language '#{language}'") unless addend.language == language
			@code += addend.code
			@comments += addend.comments
			@blanks += addend.blanks
			@filecount += addend.filecount
			self
		end
	end
end
