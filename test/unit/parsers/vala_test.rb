require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::ValaTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("vala", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "vala")
	end

	def test_comprehensive
		verify_parse("vala1.vala")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'vala', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'vala', :comment).first)
	end
end
