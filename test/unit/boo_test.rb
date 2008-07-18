require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::BooTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("boo", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "boo")
	end

  def test_block_comment
    lb = [Ohcount::LanguageBreakdown.new("boo", "", "/*comment*/", 0)]
    assert_equal lb, Ohcount::parse(" /*comment*/", "boo")
  end

  def test_nested_block_comment
    lb = [Ohcount::LanguageBreakdown.new("boo", "", "/* comment\n/* nested */\nstill a comment */", 0)]
    assert_equal lb, Ohcount::parse(" /* comment\n /* nested */\n still a comment */", "boo")
  end

  def test_doc_comments
    lb = [Ohcount::LanguageBreakdown.new("boo", "", "\"\"\"\ndoc comment\n\"\"\"", 0)]
    assert_equal lb, Ohcount::parse("\"\"\"\ndoc comment\n\"\"\"", "boo")
  end

	def test_strings
		lb = [Ohcount::LanguageBreakdown.new("boo", "\"abc#not a 'comment\"", "", 0)]
		assert_equal lb, Ohcount::parse("\"abc#not a 'comment\"", "boo")
	end

	def test_comprehensive
		verify_parse("boo1.boo")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'boo', :comment).first)
		assert_equal('//comment', entities_array(" //comment", 'boo', :comment).first)
	end
end
