require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::DylanTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("dylan", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "dylan")
	end

	def test_comprehensive
		verify_parse("dylan1.dylan")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'dylan', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'dylan', :comment).first)
	end
end
