require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::AssemblerTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("assembler", "", "!comment\n;comment", 0)]
		assert_equal lb, Ohcount::parse(" !comment\n ;comment", "assembler")
	end

	def test_comprehensive
		verify_parse("assembler1.asm")
	end

	def test_comprehensive_2
		verify_parse("assembler2.S")
	end
end
