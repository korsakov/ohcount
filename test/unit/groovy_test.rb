require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::GroovyTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("groovy", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "groovy")
	end

	def test_comprehensive
		verify_parse("groovy1.groovy")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'groovy', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'groovy', :comment).first)
	end

end
