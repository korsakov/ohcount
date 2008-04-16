require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MakefileTest < Ohcount::Test
	def test_comprehensive
		verify_parse("Makefile")
	end
end

