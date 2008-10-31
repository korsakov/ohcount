require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::MetaFontTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("metafont", "", "% comment", 0)]
		assert_equal lb, Ohcount::parse(" % comment", "metafont")
	end

	def test_comprehensive
		verify_parse("metafont.mf")
	end

	def test_comment_entities
		assert_equal('%comment', entities_array(" %comment", 'metafont', :comment).first)
	end
end
