require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::ShellTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("shell", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "shell")
	end

	def test_comprehensive
		verify_parse("sh1.sh")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'shell', :comment).first)
	end
end
