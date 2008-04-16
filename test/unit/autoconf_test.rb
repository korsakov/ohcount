require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::AutoconfTest < Ohcount::Test
	def test_comprehensive
		verify_parse("configure.ac")
	end
end

