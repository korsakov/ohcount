require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::ScilabTest < Ohcount::Test

	def test_line_comment_1
		lb = [Ohcount::LanguageBreakdown.new("scilab", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "scilab")
	end

	def test_comprehensive
		verify_parse("scilab.sci", 'scilab')
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'scilab', :comment).first)
	end

end
