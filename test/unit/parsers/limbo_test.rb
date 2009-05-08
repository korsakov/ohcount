require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::LimboTest < Ohcount::Test

	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("limbo", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "limbo")
	end

	def test_empty_comments
		lb = [Ohcount::LanguageBreakdown.new("limbo", "","#\n", 0)]
		assert_equal lb, Ohcount::parse(" #\n", "limbo")
	end

	def test_comprehensive
		verify_parse("limbo.b")
		verify_parse("limbo.m")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'limbo', :comment).first)
	end

end
