require File.dirname(__FILE__) + '/../test_helper'

class HtmlTest < LingoTest


	def test_css
#		html = " <style type=\"text/css\">\np {\n color: #444\n} \n </style>"
#		html_lb = Ohcount::LanguageBreakdown.new("html", " <style type=\"text/css\">\n </style>", "", 0)
#		css_lb = Ohcount::LanguageBreakdown.new("css", "p {\n color: #444\n} \n", "", 0)
#		parsed_lb = Ohcount::parse(html, "html")
#		assert_equal 2, parsed_lb.size
#		assert_equal html_lb, parsed_lb[0]
#		assert_equal css_lb, parsed_lb[1]
	end


	def test_comment
#		lb = [Ohcount::LanguageBreakdown.new("html", "", " <!-- comment -->", 0)]
#		assert_equal lb, Ohcount::parse(" <!-- comment -->", "html")
	end

		def test_comprehensive
			verify_parse("html1.html")
		end
end
