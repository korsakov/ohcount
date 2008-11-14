require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::VbAspxTest < Ohcount::Test

	def test_comment
		html_lb = Ohcount::LanguageBreakdown.new("html", "<%\n%>", "", 0)
		vb_lb = Ohcount::LanguageBreakdown.new("visualbasic", "", "'comment\n", 0)
		assert_equal [html_lb, vb_lb], Ohcount::parse("<%\n 'comment\n%>", "vb_aspx")
	end

	def test_comprehensive
		verify_parse("vb.aspx")
	end

end
