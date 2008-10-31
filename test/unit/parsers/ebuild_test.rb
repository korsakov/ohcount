require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::EbuildTest < Ohcount::Test
	def test_comprehensive
		verify_parse("foo.ebuild")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'ebuild', :comment).first)
	end
end
