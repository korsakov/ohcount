require File.dirname(__FILE__) + '/../test_helper'

class CTest < LingoTest

	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("sql", "", "--comment", 0)]
		assert_equal lb, Ohcount::parse(" --comment", "sql")
	end

	def test_empty_comments
		lb = [Ohcount::LanguageBreakdown.new("sql", "","--\n", 0)]
		assert_equal lb, Ohcount::parse(" --\n", "sql")
	end

	def test_block_comment
		lb = [Ohcount::LanguageBreakdown.new("sql", "","{sql}", 0)]
		assert_equal lb, Ohcount::parse(" {sql}", "sql")
	end

	def test_comprehensive
		verify_parse("sql1.sql")
	end

end
