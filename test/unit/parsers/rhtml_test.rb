require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::RhtmlTest < Ohcount::Test

	def test_comment
		html_lb = Ohcount::LanguageBreakdown.new("html", "<%\n%>", "", 0)
		ruby_lb = Ohcount::LanguageBreakdown.new("ruby", "", "#comment\n", 0)
		assert_equal [html_lb, ruby_lb], Ohcount::parse("<%\n #comment\n%>", "rhtml")
	end

	def test_comprehensive
		verify_parse("rhtml1.rhtml")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'rhtml', :comment).first)
		assert_equal('/*comment*/', entities_array("<style type='text/css'>\n/*comment*/\n</style>", 'rhtml', :comment).first)
		assert_equal('//comment', entities_array("<script type='text/javascript'>\n//comment\n</script>", 'rhtml', :comment).first)
		assert_equal('/*comment*/', entities_array("<script type='text/javascript'>\n/*comment*/\n</script>", 'rhtml', :comment).first)
		assert_equal('#comment', entities_array("<%\n#comment\n%>", 'rhtml', :comment).first)
		assert_equal("=begin\ncomment\n=end", entities_array("<%\n=begin\ncomment\n=end\n%>", 'rhtml', :comment).first)
	end

end
