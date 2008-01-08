require File.dirname(__FILE__) + '/../test_helper'

class XmlTest < LingoTest
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("xml", "", "<!--comment-->", 0)]
		assert_equal lb, Ohcount::parse(" <!--comment-->", "xml")
	end

	def test_comprehensive
		verify_parse("xml1.xml")
	end
end
