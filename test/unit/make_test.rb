require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MakefileTest < Ohcount::Test
	def test_comprehensive
		verify_parse("Makefile")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'make', :comment).first)
	end

end

