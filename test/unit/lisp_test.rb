require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::LispTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("lisp", "", ";;; comment", 0)]
		assert_equal lb, Ohcount::parse(" ;;; comment", "lisp")
	end

	def test_doc_string
		lb = [Ohcount::LanguageBreakdown.new("lisp", "", '""" comment """', 0)]
		assert_equal lb, Ohcount::parse(' """ comment """', "lisp")
	end

	def test_doc_string_blank
		lb = [Ohcount::LanguageBreakdown.new("lisp", "", '""""""', 0)]
		assert_equal lb, Ohcount::parse(' """"""', "lisp")
	end

	def test_empty_string
		lb = [Ohcount::LanguageBreakdown.new("lisp", '""', "", 0)]
		assert_equal lb, Ohcount::parse(' ""', "lisp")
	end

	def test_char_string
		lb = [Ohcount::LanguageBreakdown.new("lisp", '"a"', "", 0)]
		assert_equal lb, Ohcount::parse(' "a"', "lisp")
	end

	def test_comprehensive
		verify_parse("lsp1.lsp")
	end
end
