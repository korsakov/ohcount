require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::HaskellTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("haskell", "", "--comment", 0)]
		assert_equal lb, Ohcount::parse(" --comment", "haskell")
	end

	def test_comprehensive
		verify_parse("haskell1.hs")
	end

	def test_comprehensive_with_carriage_returns
		verify_parse("haskell2.hs")
	end

	def test_comprehensive_with_nested_comments
		verify_parse("haskell3.hs")
	end

	def test_comment_entities
		assert_equal('--comment', entities_array(" --comment", 'haskell', :comment).first)
		assert_equal('{-comment-}', entities_array(" {-comment-}", 'haskell', :comment).first)
	end
end
