require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::AutomakeTest < Ohcount::Test
	def test_comprehensive
		verify_parse("Makefile.am")
	end
end

