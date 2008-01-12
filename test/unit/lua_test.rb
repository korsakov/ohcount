require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::LuaTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("lua", "", "-- comment", 0)]
		assert_equal lb, Ohcount::parse(" -- comment", "lua")
	end

	def test_comprehensive
		verify_parse("lua1.lua")
	end
end
