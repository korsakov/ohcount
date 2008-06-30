require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::OcamlTest < Ohcount::Test
  def test_regular_comments
		lb = [Ohcount::LanguageBreakdown.new("ocaml", "", "(* comment *)", 0)]
		assert_equal lb, Ohcount::parse(" (* comment *)", "ocaml")
	end

	def test_comprehensive
		verify_parse("ocaml.ml")
	end
end
