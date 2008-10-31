require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::CSharpTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("csharp", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "csharp")
	end

	def test_comprehensive
		verify_parse("cs1.cs")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'csharp', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'csharp', :comment).first)
	end

end
