require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::VimTest < Ohcount::Test
	def test_comprehensive
		verify_parse("foo.vim")
	end
end
