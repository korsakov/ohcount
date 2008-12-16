require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::ObjectiveJTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("objective_j", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "objective_j")
	end

	def test_comprehensive
		verify_parse("objj.j")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'objective_j', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'objective_j', :comment).first)
	end

end
