module Ohcount
	# Tracks total lines of code, comments, and blanks for a single language
	class Loc
		attr_accessor :language, :code, :comments, :blanks

		def initialize(params={})
			@code = @comments = @blanks = 0
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
			self
		end
	end
end
