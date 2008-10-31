require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::PascalTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("pascal", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "pascal")
	end

	def test_comprehensive
		verify_parse("pascal1.pas")
		verify_parse("pascal2.pp")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'pascal', :comment).first)
		assert_equal('(*comment*)', entities_array(" (*comment*)", 'pascal', :comment).first)
		assert_equal('{comment}', entities_array(" {comment}", 'pascal', :comment).first)
	end
end
