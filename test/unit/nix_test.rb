require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::NixTest < Ohcount::Test
	def test_line_comments
		lb = [Ohcount::LanguageBreakdown.new("nix", "", "# comment", 0)]
		assert_equal lb, Ohcount::parse("# comment", "nix")
	end

	def test_comprehensive
		verify_parse("nix.nix")
	end

end
