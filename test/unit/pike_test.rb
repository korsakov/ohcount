require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::PikeTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("pike", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "pike")
	end

	def test_comments2
		lb = [Ohcount::LanguageBreakdown.new("pike", "", "/*comment*/", 0)]
		assert_equal lb, Ohcount::parse(" /*comment*/", "pike")
	end

	def test_comprehensive
		verify_parse("pike1.pike")
	end

	def test_comprehensive_pmod
		verify_parse("pike2.pmod")
	end
end
