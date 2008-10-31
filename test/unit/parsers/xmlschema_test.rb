require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::XMLSchemaTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("xmlschema", "", "<!--comment-->", 0)]
		assert_equal lb, Ohcount::parse(" <!--comment-->", "xmlschema")
	end

	def test_comprehensive
		verify_parse("schema.xsd")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'xmlschema', :comment).first)
	end
end
