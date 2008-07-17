require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::ErlangTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("erlang", "", "%%comment", 0)]
		assert_equal lb, Ohcount::parse(" %%comment", "erlang")
	end

	def test_comprehensive
		verify_parse("erl1.erl")
	end

	def test_comment_entities
		assert_equal('%comment', entities_array(" %comment", 'erlang', :comment).first)
	end

end
