require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::ScalaTest < Ohcount::Test

	def test_comprehensive
		verify_parse("scala1.scala")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'scala', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'scala', :comment).first)
	end

end
