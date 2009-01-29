require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class Ohcount::LanguageTest < Ohcount::Test
	def test_basic
		assert_equal "C++", Language.new("cpp").nice_name
		assert_equal 0, Language.new("cpp").category
	end

	def test_method_missing
		assert_equal "C++", Language.cpp.nice_name
	end
end
