require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::RhtmlTest < Ohcount::Test

	def test_comment
		html_lb = Ohcount::LanguageBreakdown.new("html", "<%\n%>", "", 0)
		ruby_lb = Ohcount::LanguageBreakdown.new("ruby", "", "#comment\n", 0)
		assert_equal [html_lb, ruby_lb], Ohcount::parse("<%\n #comment\n%>", "rhtml")
	end

	def test_comprehensive
		verify_parse("rhtml1.rhtml")
	end
end
