require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::SmalltalkTest < Ohcount::Test

	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("smalltalk", "", '"comment\\"', 0)]
		assert_equal lb, Ohcount::parse(' "comment\\"', "smalltalk")
	end

	def test_comprehensive
		verify_parse("smalltalk1.st")
	end
end
