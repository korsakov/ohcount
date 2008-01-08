require File.dirname(__FILE__) + '/../test_helper'

class JavaTest < LingoTest
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("java", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "java")
	end

	def test_comprehensive
		verify_parse("java1.java")
	end

	def test_comprehensive_with_carriage_returns
		verify_parse("java2.java")
	end
end
