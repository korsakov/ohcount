require File.dirname(__FILE__) + '/../test_helper'

class LispTest < LingoTest

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("lisp", "", ";;; comment", 0)]
		assert_equal lb, Ohcount::parse(" ;;; comment", "lisp")
	end

	def test_comprehensive
		verify_parse("lsp1.lsp")
	end
end
