require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::ScalaTest < Ohcount::Test

	def test_comprehensive
		verify_parse("scala1.scala")
	end

end
