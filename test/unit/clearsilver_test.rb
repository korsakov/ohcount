require File.dirname(__FILE__) + '/../test_helper'

class ClearsilverTest < LingoTest

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("clearsilver", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "clearsilver")
	end

end
