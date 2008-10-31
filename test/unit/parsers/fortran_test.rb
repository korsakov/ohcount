require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::FortranTest < Ohcount::Test

	def test_comprehensive
		verify_parse("fortranfixed.f")
		verify_parse("fortranfree.f")
	end

	def test_comment_entities
		assert_equal('!comment', entities_array(" !comment", 'fortranfree', :comment).first)
		assert_equal('C comment', entities_array("C comment", 'fortranfixed', :comment).first)
	end

end
