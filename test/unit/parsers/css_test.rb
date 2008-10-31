require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::CssTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("css", "", "/*comment*/", 0)]
		assert_equal lb, Ohcount::parse(" /*comment*/", "css")
	end

	def test_comprehensive
		verify_parse("css1.css")
	end

	def test_comment_entities
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'css', :comment).first)
	end
end
