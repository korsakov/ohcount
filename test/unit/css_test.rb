require File.dirname(__FILE__) + '/../test_helper'

class CssTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("css", "", "/*comment*/", 0)]
		assert_equal lb, Ohcount::parse(" /*comment*/", "css")
	end

	def test_comprehensive
		verify_parse("css1.css")
	end
end
