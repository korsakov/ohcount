require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::TeXTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("tex", "", "%comment", 0)]
		assert_equal lb, Ohcount::parse(" %comment", "tex")
	end

	def test_comprehensive
		verify_parse("foo.tex")
	end

	def test_comment_entities
		assert_equal('%comment', entities_array(" %comment", 'tex', :comment).first)
	end
end
