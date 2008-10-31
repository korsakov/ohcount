require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::JavaTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("java", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "java")
	end

	def test_comprehensive
		verify_parse("java1.java")
	end

	def test_comprehensive_with_carriage_returns
		verify_parse("java2.java")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'java', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'java', :comment).first)
	end
end
