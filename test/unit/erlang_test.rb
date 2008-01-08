require File.dirname(__FILE__) + '/../test_helper'

class ErlangTest < LingoTest

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("erlang", "", "%%comment", 0)]
		assert_equal lb, Ohcount::parse(" %%comment", "erlang")
	end

	def test_comprehensive
		verify_parse("erl1.erl")
	end
end
