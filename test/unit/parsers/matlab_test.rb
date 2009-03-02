require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::MatlabTest < Ohcount::Test

	def test_line_comment_1
		lb = [Ohcount::LanguageBreakdown.new("matlab", "", "%comment", 0)]
		assert_equal lb, Ohcount::parse(" %comment", "matlab")
	end

	def test_ancient_syntax_comment
		lb = [Ohcount::LanguageBreakdown.new("matlab", "", "... comment", 0)]
		assert_equal lb, Ohcount::parse(" ... comment", "matlab")
	end

	def test_false_line_comment
		lb = [Ohcount::LanguageBreakdown.new("matlab", "%{block%} code", "", 0)]
		assert_equal lb, Ohcount::parse(" %{block%} code", "matlab")
	end

	def test_comprehensive
		verify_parse("matlab1.m", 'matlab')
	end

	def test_comment_entities
		assert_equal('%comment', entities_array(" %comment", 'matlab', :comment).first)
		assert_equal('... comment', entities_array(" ... comment", 'matlab', :comment).first)
		assert_equal('%{comment%}', entities_array(" %{comment%}", 'matlab', :comment).first)
	end

end
