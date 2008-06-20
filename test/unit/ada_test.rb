require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::AdaTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("ada", "", "--comment", 0)]
		assert_equal lb, Ohcount::parse(" --comment", "ada")
	end

	def test_comprehensive
		verify_parse("ada1.ada")
	end

	def test_comprehensive_adb
		verify_parse("ada1.adb")
	end
end
