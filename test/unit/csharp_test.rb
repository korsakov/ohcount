require File.dirname(__FILE__) + '/../test_helper'

class CSharpTest < LingoTest

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("csharp", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "csharp")
	end

	def test_comprehensive
		verify_parse("cs1.cs")
	end
end
