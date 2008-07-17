require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::AwkTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("awk", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "awk")
	end

	def test_double_slash
		lb = [Ohcount::LanguageBreakdown.new("awk", "\"\\\\\"\n", "#comment", 0)]
		# awk doesn't recognize backslash escaping of double quote...weird
		assert_equal lb, Ohcount::parse("\"\\\\\"\n#comment", "awk")
	end

	def test_comprehensive
		verify_parse("awk1.awk")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'awk', :comment).first)
	end
end
