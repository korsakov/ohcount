require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::CmakeTest < Ohcount::Test

  def test_comments
    lb = [Ohcount::LanguageBreakdown.new("cmake", "", "#comment", 0)]
    assert_equal lb, Ohcount::parse(" #comment", "cmake")
  end

  def test_empty_comments
    lb = [Ohcount::LanguageBreakdown.new("cmake", "","#\n", 0)]
    assert_equal lb, Ohcount::parse(" #\n", "cmake")
  end

  def test_comprehensive
    verify_parse("cmake1.cmake")
  end

  def test_comment_entities
    assert_equal('#comment', entities_array(" #comment", 'cmake', :comment).first)
  end

end
