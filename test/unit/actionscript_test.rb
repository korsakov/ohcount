require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::ActionscriptTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("actionscript", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "actionscript")
	end

	def test_comprehensive
		verify_parse("as1.as")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(' //comment', 'actionscript', :comment).first)
		assert_equal('/*comment*/', entities_array(' /*comment*/', 'actionscript', :comment).first)
	end
end
