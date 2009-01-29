require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class LocDeltaTest < Ohcount::Test
	def test_loc_requires_langauge
		assert_raises(ArgumentError) { LocDelta.new }
	end

	def test_loc_delta_default
		delta = LocDelta.new('c')
		assert_equal 0, delta.code_added
		assert_equal 0, delta.code_removed
		assert_equal 0, delta.comments_added
		assert_equal 0, delta.comments_removed
		assert_equal 0, delta.blanks_added
		assert_equal 0, delta.blanks_removed
	end

	def test_loc_delta_initializer
		delta = LocDelta.new("c", :code_added => 1, :code_removed => 10,
											 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		assert_equal "c", delta.language
		assert_equal 1, delta.code_added
		assert_equal 10, delta.code_removed
		assert_equal 2, delta.comments_added
		assert_equal 20, delta.comments_removed
		assert_equal 3, delta.blanks_added
		assert_equal 30, delta.blanks_removed
	end

	def test_net_total
		delta = LocDelta.new("c", :code_added => 1, :code_removed => 10,
											 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		assert_equal -9, delta.net_code
		assert_equal -18, delta.net_comments
		assert_equal -27, delta.net_blanks
		assert_equal -54, delta.net_total
	end

	def test_addition
		delta = LocDelta.new("c", :code_added => 1, :code_removed => 10,
											 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		delta += LocDelta.new("c", :code_added => 100, :code_removed => 1000,
											 :comments_added => 200, :comments_removed => 2000, :blanks_added => 300, :blanks_removed => 3000)
		assert_equal 101, delta.code_added
		assert_equal 1010, delta.code_removed
		assert_equal 202, delta.comments_added
		assert_equal 2020, delta.comments_removed
		assert_equal 303, delta.blanks_added
		assert_equal 3030, delta.blanks_removed
	end

	def test_addition_requires_matching_language
		delta = LocDelta.new("c")
		assert_raises(ArgumentError) do
			delta += LocDelta.new("java")
		end
	end
end

