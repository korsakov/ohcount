require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::BatTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("bat", "", "REM comment", 0)]
		assert_equal lb, Ohcount::parse(" REM comment", "bat")
	end

	def test_comprehensive
		verify_parse("bat1.bat")
	end

	def test_comment_entities
		assert_equal('rem comment', entities_array(" rem comment", 'bat', :comment).first)
	end
end
