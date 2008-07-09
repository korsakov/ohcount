require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::FactorTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("factor", "", "! comment", 0)]
		assert_equal lb, Ohcount::parse(" ! comment", "factor")
	end

	def test_strings
		lb = [Ohcount::LanguageBreakdown.new("factor", "\"abc!not a 'comment\"", "", 0)]
		assert_equal lb, Ohcount::parse("\"abc!not a 'comment\"", "factor")
	end

	def test_comprehensive
		verify_parse("factor1.factor")
	end
end
