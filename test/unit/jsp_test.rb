require File.dirname(__FILE__) + '/../test_helper'

class JspTest < LingoTest
	def test_comment
#		html_lb = Ohcount::LanguageBreakdown.new("html", "<%\n%>", "", 0)
#		java_lb = Ohcount::LanguageBreakdown.new("java", "", " //comment\n", 0)
#		assert_equal [html_lb, java_lb], Ohcount::parse("<%\n //comment\n%>", "jsp")
	end

	def test_comment2
		html_lb = Ohcount::LanguageBreakdown.new("html", "%>", "", 0)
		java_lb = Ohcount::LanguageBreakdown.new("java", "", "<% //comment\n", 0)
		assert_equal [java_lb, html_lb], Ohcount::parse(" <% //comment\n%>", "jsp")
	end

	def test_comprehensive
		verify_parse("jsp1.jsp")
	end
end
