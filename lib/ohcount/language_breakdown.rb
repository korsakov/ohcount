class Ohcount::LanguageBreakdown

	def ==(other) #:nodoc:
		return self.name == other.name && self.code == other.code && self.comment == other.comment && self.blanks == other.blanks
	end

	def inspect # :nodoc:
		return "<'#{ self.name }'-code(|#{ self.code_count } lines| \"#{ self.code.abbr.gsub("\n", "\\n") }\")/comments(|#{ self.comment_count } lines| \"#{ self.comment.abbr }\")/blanks:#{ self.blanks }>"
	end

end
