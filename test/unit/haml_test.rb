require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::HamlTest < Ohcount::Test
	def test_line_comment
		lb = [Ohcount::LanguageBreakdown.new("haml", "", "/ comment", 0)]
		assert_equal lb, Ohcount::parse("/ comment", "haml")
	end

	def test_element
		lb2 = [Ohcount::LanguageBreakdown.new("haml", "%code", "", 0)]
		assert_equal lb2, Ohcount::parse("  %code", "haml")
	end

	def test_element_entities
		assert_equal("%element", entities_array(" %element", 'haml', :element).first)
		assert_equal(".class", entities_array(" .class", 'haml', :element_class).first)
		assert_equal("#id", entities_array(" #id", 'haml', :element_id).first)
	end

	def test_comprehensive
		verify_parse("haml.haml")
	end
end
