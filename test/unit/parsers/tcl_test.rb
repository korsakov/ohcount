require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::TclTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("tcl", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "tcl")
	end

	def test_comprehensive
		verify_parse("tcl1.tcl")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'tcl', :comment).first)
	end
end
