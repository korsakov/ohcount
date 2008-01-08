require File.dirname(__FILE__) + '/../test_helper'

class PascalTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("pascal", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "pascal")
	end

	def test_comprehensive
		verify_parse("pascal1.pas")
		verify_parse("pascal2.pp")
	end
end
