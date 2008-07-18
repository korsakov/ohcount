require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::VisualBasicTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("visualbasic", "", "'comment", 0)]
		assert_equal lb, Ohcount::parse(" 'comment", "visualbasic")
	end

	def test_comprehensive
		verify_parse("frx1.frx")
	end

	def test_comment_entities
		assert_equal('\'comment', entities_array(" 'comment", 'visualbasic', :comment).first)
		assert_equal('Rem comment', entities_array(" Rem comment", 'visualbasic', :comment).first)
	end
end
