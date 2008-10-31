require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::ExheresTest < Ohcount::Test
	def test_comprehensive
		verify_parse("foo.exheres-0")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'exheres', :comment).first)
	end
end

