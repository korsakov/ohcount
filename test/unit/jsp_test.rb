require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::JspTest < Ohcount::Test
	def test_comment
		html_lb = Ohcount::LanguageBreakdown.new("html", "%>", "", 0)
		java_lb = Ohcount::LanguageBreakdown.new("java", "", "<% //comment\n", 0)
		assert_equal [java_lb, html_lb], Ohcount::parse(" <% //comment\n%>", "jsp")
	end

	def test_comprehensive
		verify_parse("jsp1.jsp")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'jsp', :comment).first)
		assert_equal('/*comment*/', entities_array("<style type='text/css'>\n/*comment*/\n</style>", 'jsp', :comment).first)
		assert_equal('//comment', entities_array("<%\n//comment\n%>", 'jsp', :comment).first)
		assert_equal('/*comment*/', entities_array("<%\n/*comment*/\n%>", 'jsp', :comment).first)
	end
end
