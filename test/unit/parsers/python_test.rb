require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::PythonTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("python", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "python")
	end

  def test_doc_comment
    lb = [Ohcount::LanguageBreakdown.new("python", "", "'''\ndoc comment\n'''", 0)]
    assert_equal lb, Ohcount::parse("  '''\n  doc comment\n  '''", "python")
  end

	def test_strings
		lb = [Ohcount::LanguageBreakdown.new("python", "\"abc#not a 'comment\"", "", 0)]
		assert_equal lb, Ohcount::parse("\"abc#not a 'comment\"", "python")
	end

	def test_comprehensive
		verify_parse("py1.py")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'python', :comment).first)
		assert_equal('"""comment"""', entities_array(" \"\"\"comment\"\"\"", 'python', :comment).first)
	end
end
