require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::RubyTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("ruby", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "ruby")
	end

	def test_comprehensive
		verify_parse("ruby1.rb")
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'ruby', :comment).first)
		assert_equal("=begin\ncomment\n=end", entities_array("=begin\ncomment\n=end", 'ruby', :comment).first)
	end

end
