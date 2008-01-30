require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::TeXTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("tex", "", "%comment", 0)]
		assert_equal lb, Ohcount::parse(" %comment", "tex")
	end

	def test_comprehensive
		verify_parse("foo.tex")
	end
end
