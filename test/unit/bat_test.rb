require File.dirname(__FILE__) + '/../test_helper'

class BatTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("bat", "", "REM comment", 0)]
		assert_equal lb, Ohcount::parse(" REM comment", "bat")
	end

	def test_comprehensive
		verify_parse("bat1.bat")
	end
end
