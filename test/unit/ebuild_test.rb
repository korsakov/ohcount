require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::EbuildTest < Ohcount::Test
	def test_comprehensive
		verify_parse("foo.ebuild")
	end
end
