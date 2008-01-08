class Ohcount::LanguageBreakdown

	def ==(other)
		return self.name == other.name && self.code == other.code && self.comment == other.comment && self.blanks == other.blanks
	end

	def abbr(s, len=80)
		s.size > len ? s[0..(len-3)] + "..." : s
	end

	def inspect
		return "<[#{ self.name }]-code(#{ abbr(self.code).gsub("\n", "\\n") })/comment(#{ abbr(self.comment) })/blanks:#{ self.blanks }>"
	end

end
