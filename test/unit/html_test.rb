require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::HtmlTest < Ohcount::Test
	def test_comprehensive
		verify_parse("html1.html")
	end
end
