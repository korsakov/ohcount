require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::CsAspxTest < Ohcount::Test

	def test_comment
		html_lb = Ohcount::LanguageBreakdown.new("html", "<%\n%>", "", 0)
		csharp_lb = Ohcount::LanguageBreakdown.new("csharp", "", "//comment\n", 0)
		assert_equal [html_lb, csharp_lb], Ohcount::parse("<%\n //comment\n%>", "cs_aspx")
	end

	def test_comprehensive
		verify_parse("cs.aspx")
	end

end
