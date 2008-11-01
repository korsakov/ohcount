require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::GLSLTest < Ohcount::Test

	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("glsl", "", "//comment", 0)]
		assert_equal lb, Ohcount::parse(" //comment", "glsl")
	end

	def test_empty_comments
		lb = [Ohcount::LanguageBreakdown.new("glsl", "","//\n", 0)]
		assert_equal lb, Ohcount::parse(" //\n", "glsl")
	end


	def test_block_comment
		lb = [Ohcount::LanguageBreakdown.new("glsl", "","/*glsl*/", 0)]
		assert_equal lb, Ohcount::parse("/*glsl*/", "glsl")
	end

	def test_comprehensive
		verify_parse("foo.glsl")
		verify_parse("foo_glsl.vert")
	end

	def test_comment_entities
		assert_equal('//comment', entities_array(" //comment", 'glsl', :comment).first)
		assert_equal('/*comment*/', entities_array(" /*comment*/", 'glsl', :comment).first)
	end

end
