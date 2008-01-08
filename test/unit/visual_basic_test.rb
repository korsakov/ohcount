require File.dirname(__FILE__) + '/../test_helper'

class VisualBasicTest < LingoTest
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("visualbasic", "", "'comment", 0)]
		assert_equal lb, Ohcount::parse(" 'comment", "visualbasic")
	end

	def test_comprehensive
		verify_parse("frx1.frx")
	end
end
