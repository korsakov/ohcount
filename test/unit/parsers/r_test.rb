require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::RTest < Ohcount::Test

	def test_line_comment_1
		lb = [Ohcount::LanguageBreakdown.new("r", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "r")
	end

	def test_comprehensive
		verify_parse("example.R", 'r')
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'r', :comment).first)
	end

end
