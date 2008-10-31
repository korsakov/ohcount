require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::LuaTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("lua", "", "-- comment", 0)]
		assert_equal lb, Ohcount::parse(" -- comment", "lua")
	end

	def test_comprehensive
		verify_parse("lua1.lua")
	end

	def test_comment_entities
		assert_equal('--comment', entities_array(" --comment", 'lua', :comment).first)
		assert_equal("--[[comment\ncomment]]", entities_array(" --[[comment\ncomment]]", 'lua', :comment).first)
	end

end
