require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::EmacsLispTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("emacslisp", "", ";;comment", 0)]
		assert_equal lb, Ohcount::parse(" ;;comment", "emacslisp")
	end

	def test_comprehensive
		verify_parse("el1.el")
	end
end


