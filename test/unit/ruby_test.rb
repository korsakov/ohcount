require File.dirname(__FILE__) + '/../test_helper'

class RubyTest < LingoTest

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("ruby", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "ruby")
	end

	def test_comprehensive
		verify_parse("ruby1.rb")
	end
end
