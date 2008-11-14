require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::XamlTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("xaml", "", "<!--comment-->", 0)]
		assert_equal lb, Ohcount::parse(" <!--comment-->", "xaml")
	end

	def test_comprehensive
		verify_parse("click_me.xaml")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'xaml', :comment).first)
	end
end
