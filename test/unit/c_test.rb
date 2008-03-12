require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::CTest < Ohcount::Test

	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("c", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "c")
	end

	def test_empty_comments
		lb = [Ohcount::LanguageBreakdown.new("c", "","//\n", 0)]
		assert_equal lb, Ohcount::parse(" //\n", "c")
	end


	def test_block_comment
		lb = [Ohcount::LanguageBreakdown.new("c", "","/*c*/", 0)]
		assert_equal lb, Ohcount::parse("/*c*/", "c")
	end

	def test_comprehensive
		verify_parse("c1.c")
	end

end
