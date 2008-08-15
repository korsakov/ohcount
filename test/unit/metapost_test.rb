require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MetaPostTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("metapost", "", "% comment", 0)]
		assert_equal lb, Ohcount::parse(" % comment", "metapost")
	end

	def test_comprehensive
		verify_parse("metapost.mp")
	end

	def test_comment_entities
		assert_equal('%comment', entities_array(" %comment", 'metapost', :comment).first)
		assert_equal('%comment', entities_array("verbatim\n%comment\netex", 'metapost', :comment).first)
	end
end
