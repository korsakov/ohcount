require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::OctaveTest < Ohcount::Test

	def test_line_comment_1
		lb = [Ohcount::LanguageBreakdown.new("octave", "", "%comment", 0)]
		assert_equal lb, Ohcount::parse(" %comment", "octave")
	end

	def test_octave_syntax_comment
		lb = [Ohcount::LanguageBreakdown.new("octave", "", "# comment", 0)]
		assert_equal lb, Ohcount::parse(" # comment", "octave")
	end

	# Note: GNU Octave doesn't support block comments *yet*, but it might in the future.
	def test_false_line_comment
		lb = [Ohcount::LanguageBreakdown.new("octave", "%{block%} code", "", 0)]
		assert_equal lb, Ohcount::parse(" %{block%} code", "octave")
	end

	def test_comprehensive
		verify_parse("octave1.m", 'octave')
	end

	def test_comment_entities
		assert_equal('%comment', entities_array(" %comment", 'octave', :comment).first)
		assert_equal('# comment', entities_array(" # comment", 'octave', :comment).first)
	end

end
