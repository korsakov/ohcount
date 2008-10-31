require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::DclTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("dcl", "", "$!comment", 0)]
		assert_equal lb, Ohcount::parse("$!comment", "dcl")
	end

	def test_code
		lb= [Ohcount::LanguageBreakdown.new("dcl", "$code", "", 0)]
		assert_equal lb, Ohcount::parse("$code", "dcl")
	end

	def test_blank
		lb=[Ohcount::LanguageBreakdown.new("dcl", "", "", 1)]
		assert_equal lb, Ohcount::parse("\n", "dcl")
	end

	def test_input_line
		lb=[Ohcount::LanguageBreakdown.new("dcl", "input", "", 0)]
		assert_equal lb, Ohcount::parse("input", "dcl")
	end


	def test_comprehensive
		verify_parse("dcl.com")
	end

	def test_comment_entities
		assert_equal('!comment', entities_array(" !comment", 'dcl', :comment).first)
	end
end
