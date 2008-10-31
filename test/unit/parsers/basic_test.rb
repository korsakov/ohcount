require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::BasicTest < Ohcount::Test
	def test_sb_comments
		lb = [Ohcount::LanguageBreakdown.new("structured_basic", "", "REM comment", 0)]
		assert_equal lb, Ohcount::parse("REM comment", "structured_basic")
	end

  def test_cb_comments
		lb = [Ohcount::LanguageBreakdown.new("classic_basic", "", "100 REM comment", 0)]
		assert_equal lb, Ohcount::parse(" 100 REM comment", "classic_basic")
	end

	def test_comprehensive
		verify_parse("classic_basic.b")
		verify_parse("visual_basic.bas", ["frx1.frx"])
		verify_parse("structured_basic.b")
		verify_parse("structured_basic.bas")
		verify_parse("classic_basic.bas")
	end

	def test_comment_entities
		assert_equal('REM comment', entities_array(" REM comment", 'structured_basic', :comment).first)
		assert_equal('\'comment', entities_array(" 'comment", 'classic_basic', :comment).first)
	end
end
