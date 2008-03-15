require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MetaPostTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("metapost", "", "% comment", 0)]
		assert_equal lb, Ohcount::parse(" % comment", "metapost")
	end

	def test_comprehensive
		verify_parse("metapost.mp")
	end
end
