class String

	# Generic string abbreviation function.
	#
	# Example:
	#  "foobar".abbr(5)  => "fo..."
	#
	def abbr(len=80)
		size > len ? self[0..(len-3)] + "..." : self
	end
end

