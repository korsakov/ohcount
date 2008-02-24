require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::FortranTest < Ohcount::Test

	def test_comprehensive
		verify_parse("fortranfixed.f")
		verify_parse("fortranfree.f")
	end

end
