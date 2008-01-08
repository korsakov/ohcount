require File.dirname(__FILE__) + '/../test_helper'

class GroovyTest < LingoTest
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("groovy", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "groovy")
	end

	def test_comprehensive
		verify_parse("groovy1.groovy")
	end

end
