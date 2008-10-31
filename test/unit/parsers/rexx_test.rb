require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::RexxTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("rexx", "", "/*comment*/", 0)]
		assert_equal lb, Ohcount::parse(" /*comment*/", "rexx")
	end

	def test_comprehensive
		verify_parse("rexx1.rex")
	end

	def test_comment_entities
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'rexx', :comment).first)
	end

end
