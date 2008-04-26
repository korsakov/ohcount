require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MxmlTest < Ohcount::Test
	def test_comprehensive
		verify_parse("mxml1.mxml")
	end
end
