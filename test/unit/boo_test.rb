require File.dirname(__FILE__) + '/../test_helper'

class BooTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("boo", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "boo")
	end

	def test_strings
		lb = [Ohcount::LanguageBreakdown.new("boo", "'''abc\n#not a 'comment\n'''", "", 0)]
		assert_equal lb, Ohcount::parse("'''abc\n#not a 'comment\n'''", "boo")
	end

	def test_comprehensive
		verify_parse("boo1.boo")
	end
end
