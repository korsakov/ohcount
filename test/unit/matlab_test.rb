require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MatlabTest < Ohcount::Test

	def test_line_comment_1
		lb = [Ohcount::LanguageBreakdown.new("matlab", "", "%comment", 0)]
		assert_equal lb, Ohcount::parse(" %comment", "matlab")
	end

	def test_line_comment_2
		lb = [Ohcount::LanguageBreakdown.new("matlab", "", "%comment", 0)]
		assert_equal lb, Ohcount::parse("%comment", "matlab")
	end

	def test_octave_syntax_comment
		lb = [Ohcount::LanguageBreakdown.new("matlab", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "matlab")
	end

	# matlab is slightly weird in that '%' starts a line comment
	# while '{%' starts a block comment. To make sure we aren't
	# misinterpreting '{%' as a line comment, the following test
	# adds code after a single-line block comment. If it interprets the
	# {% as a line comment (ie: just %) then it will ignore everything else
	# after and attribute the line as comment
	def test_false_line_comment
		lb = [Ohcount::LanguageBreakdown.new("matlab", "{%block%} code", "", 0)]
		assert_equal lb, Ohcount::parse(" {%block%} code", "matlab")
	end

	def test_comprehensive
		verify_parse("matlab1.m", 'matlab')
	end
end
