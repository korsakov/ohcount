require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::HaxeTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("haxe", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "haxe")
	end

	def test_comprehensive
		verify_parse("haxe1.hx")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(' //comment', 'haxe', :comment).first)
		assert_equal('/*comment*/', entities_array(' /*comment*/', 'haxe', :comment).first)
	end
end
