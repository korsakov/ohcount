require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::StrategoTest < Ohcount::Test
	def test_line_comments
		lb = [Ohcount::LanguageBreakdown.new("stratego", "", "// comment", 0)]
		assert_equal lb, Ohcount::parse("// comment", "stratego")
	end

	def test_comprehensive
		verify_parse("stratego.str")
	end

	def test_char_string_entities
		assert_equal("'c'", entities_array(" 'c'", 'stratego', :string).first)
    # single quote can be used in identiiers
    # weak case
		assert_not_equal(" c'", entities_array(" c'", 'stratego', :string).first)
    # strong case
    assert_not_equal("' = e'", entities_array(" c' = e'", 'stratego', :string).first)
	end

end
