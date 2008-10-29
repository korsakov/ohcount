require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::BlitzMaxTest < Ohcount::Test
	def test_sb_comments
		lb = [Ohcount::LanguageBreakdown.new("blitzmax", "", "' comment", 0)]
		assert_equal lb, Ohcount::parse("' comment", "blitzmax")
	end

	def test_comprehensive
		verify_parse("blitzmax.bmx")
	end

	def test_comment_entities
		assert_equal('\' comment', entities_array(" ' comment", 'blitzmax', :comment).first)
	end
end
