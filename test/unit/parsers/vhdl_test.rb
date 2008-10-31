require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::VHDLTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("vhdl", "", "-- comment", 0)]
		assert_equal lb, Ohcount::parse(" -- comment", "vhdl")
	end

	def test_comprehensive
		verify_parse("vhdl1.vhd")
	end

	def test_comment_entities
		assert_equal('--comment', entities_array(" --comment", 'vhdl', :comment).first)
	end
end
