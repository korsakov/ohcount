require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::XsltTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("xslt", "", "<!--comment-->", 0)]
		assert_equal lb, Ohcount::parse(" <!--comment-->", "xslt")
	end

	def test_comprehensive
		verify_parse("example.xsl")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'xslt', :comment).first)
	end
end
