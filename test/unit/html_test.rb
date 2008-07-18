require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::HtmlTest < Ohcount::Test
	def test_comprehensive
		verify_parse("html1.html")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'html', :comment).first)
	end
end
