require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::EiffelTest < Ohcount::Test
  def test_cb_comments
		lb = [Ohcount::LanguageBreakdown.new("eiffel", "", "-- comment", 0)]
		assert_equal lb, Ohcount::parse(" -- comment", "eiffel")
	end

	def test_comprehensive
		verify_parse("eiffel.e")
	end

	def test_comment_entities
		assert_equal('--comment', entities_array(" --comment", 'eiffel', :comment).first)
	end

end
