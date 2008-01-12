require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::PythonTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("python", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "python")
	end

	def test_strings
		lb = [Ohcount::LanguageBreakdown.new("python", "'''abc\n#not a 'comment\n'''", "", 0)]
		assert_equal lb, Ohcount::parse("'''abc\n#not a 'comment\n'''", "python")
	end

	def test_comprehensive
		verify_parse("py1.py")
	end
end
