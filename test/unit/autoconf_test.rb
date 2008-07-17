require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::AutoconfTest < Ohcount::Test
	def test_comprehensive
		verify_parse("configure.ac")
	end

	def test_comment_entities
		assert_equal('dnl comment', entities_array(" dnl comment", 'autoconf', :comment).first)
	end
end

