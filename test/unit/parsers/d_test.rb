require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::DTest < Ohcount::Test

	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("dmd", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "dmd")
	end

	def test_empty_comments
		lb = [Ohcount::LanguageBreakdown.new("dmd", "","//\n", 0)]
		assert_equal lb, Ohcount::parse(" //\n", "dmd")
	end

	def test_strings
		lb = [Ohcount::LanguageBreakdown.new("dmd", "'/*' not a comment '*/'", "", 0)]
		assert_equal lb, Ohcount::parse("'/*' not a comment '*/'", "dmd")
	end

	def test_block_comment
		lb = [Ohcount::LanguageBreakdown.new("dmd", "","/*d*/", 0)]
		assert_equal lb, Ohcount::parse("/*d*/", "dmd")

		lb = [Ohcount::LanguageBreakdown.new("dmd", "","/+d+/", 0)]
		assert_equal lb, Ohcount::parse("/+d+/", "dmd")
	end

	def test_nested_block_comment
		lb = [Ohcount::LanguageBreakdown.new("dmd", "","/+ /*d*/ not_code(); +/", 0)]
		assert_equal lb, Ohcount::parse("/+ /*d*/ not_code(); +/", "dmd")
	end

	def test_comprehensive
		verify_parse("d1.d")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'dmd', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'dmd', :comment).first)
		assert_equal('/+comment+/', entities_array(" /+comment+/", 'dmd', :comment).first)
	end

end
