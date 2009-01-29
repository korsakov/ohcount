require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class LocTest < Ohcount::Test
	def test_loc_requires_language
		assert_raises(ArgumentError) { Loc.new }
	end

	def test_loc_default
		loc = Loc.new('c')
		assert_equal 'c', loc.language
		assert_equal 0, loc.code
		assert_equal 0, loc.comments
		assert_equal 0, loc.blanks
	end

	def test_loc_initializer
		loc = Loc.new("c", :code => 1, :comments => 2, :blanks => 3)
		assert_equal "c", loc.language
		assert_equal 1, loc.code
		assert_equal 2, loc.comments
		assert_equal 3, loc.blanks
		assert_equal 6, loc.total
	end

	def test_add
		loc = Loc.new("c", :code => 1, :comments => 2, :blanks => 3)
		loc += Loc.new("c", :code => 10, :comments => 20, :blanks => 30)
		assert_equal 'c', loc.language
		assert_equal 11, loc.code
		assert_equal 22, loc.comments
		assert_equal 33, loc.blanks
		assert_equal 66, loc.total
	end

	def test_add_requires_same_language
		loc = Loc.new("c", :code => 1, :comments => 2, :blanks => 3)
		assert_raises(ArgumentError) do
			loc += Loc.new("java", :code => 10, :comments => 20, :blanks => 30)
		end
	end
end
