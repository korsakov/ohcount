require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::CTest < Ohcount::Test

	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("cncpp", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "cncpp")
	end

	def test_empty_comments
		lb = [Ohcount::LanguageBreakdown.new("cncpp", "","//\n", 0)]
		assert_equal lb, Ohcount::parse(" //\n", "cncpp")
	end


	def test_block_comment
		lb = [Ohcount::LanguageBreakdown.new("cncpp", "","/*c*/", 0)]
		assert_equal lb, Ohcount::parse("/*c*/", "cncpp")
	end

	def test_comprehensive
		verify_parse("c1.c")
		verify_parse("c_str.c")
	end

	def test_comprehensive_in
		verify_parse("c2.h.in")
	end

end
