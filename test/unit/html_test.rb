require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::HtmlTest < Ohcount::Test
	def test_comprehensive
		verify_parse("html1.html")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'html', :comment).first)
		assert_equal('/*comment*/', entities_array("<style type='text/css'>\n/*comment*/\n</style>", 'html', :comment).first)
		assert_equal('//comment', entities_array("<script type='text/javascript'>\n//comment\n</script>", 'html', :comment).first)
		assert_equal('/*comment*/', entities_array("<script type='text/javascript'>\n/*comment*/\n</script>", 'html', :comment).first)
	end
end
