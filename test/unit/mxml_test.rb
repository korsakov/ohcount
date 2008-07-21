require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::MxmlTest < Ohcount::Test
	def test_comprehensive
		verify_parse("mxml1.mxml")
	end

	def test_comment_entities
		assert_equal('<!--comment-->', entities_array(" <!--comment-->", 'mxml', :comment).first)
		assert_equal('/*comment*/', entities_array("<mx:Style>\n/*comment*/\n</mx:Style>", 'mxml', :comment).first)
		assert_equal('//comment', entities_array("<mx:Script>\n//comment\n</mx:Script>", 'mxml', :comment).first)
		assert_equal('/*comment*/', entities_array("<mx:Script>\n/*comment*/\n</mx:Script>", 'mxml', :comment).first)
	end
end
