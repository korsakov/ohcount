# LanguageBreakdown is a helper struct. Most of its methods are defined in the C code.
# It has the following properties:
#
# name: The name of the language found
#
# code: A string containing all lines from the parsed buffer that contained code in language <name>.
#
# comment: A string containing all lines from the parsed buffer that contained only comments (no code) in language <name>.
#
# blanks: The number of blank lines found while parsing language <name>.
#
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
