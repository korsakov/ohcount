require File.dirname(__FILE__) + '/../test_helper'

class TclTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("tcl", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "tcl")
	end

	def test_comprehensive
		verify_parse("tcl1.tcl")
	end
end
