require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::SchemeTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("scheme", "", ";;; comment", 0)]
		assert_equal lb, Ohcount::parse(" ;;; comment", "scheme")
	end

	def test_comprehensive
		verify_parse("scheme.scm")
	end
end
