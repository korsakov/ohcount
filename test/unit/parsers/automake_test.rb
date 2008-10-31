require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::AutomakeTest < Ohcount::Test
	def test_comprehensive
		verify_parse("Makefile.am")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'automake', :comment).first)
	end
end

