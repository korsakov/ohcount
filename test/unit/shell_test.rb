require File.dirname(__FILE__) + '/../test_helper'

class ShellTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("shell", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "shell")
	end

	def test_comprehensive
		verify_parse("sh1.sh")
	end
end
