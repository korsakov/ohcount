require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class LocDeltaListTest < Ohcount::Test
	def test_loc_list_default
		list = LocDeltaList.new
		assert_equal [], list.loc_deltas
		assert_equal [], list.languages
	end

	def test_loc_selector
		list = LocDeltaList.new
		c = LocDelta.new('c')
		java = LocDelta.new('java')

		list.loc_deltas = [c, java]

		assert_equal c, list.loc_delta('c')
		assert_equal java, list.loc_delta('java')
	end

	def test_first_add
		list = LocDeltaList.new
		loc_delta = LocDelta.new('c', :code_added => 1, :code_removed => 10,
														 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		list += loc_delta

		assert_equal ['c'], list.languages
		assert_equal 1, list.code_added
		assert_equal 10, list.code_removed
		assert_equal 2, list.comments_added
		assert_equal 20, list.comments_removed
		assert_equal 3, list.blanks_added
		assert_equal 30, list.blanks_removed
	end

	def test_add_two_languages
		list = LocDeltaList.new

		c = LocDelta.new('c', :code_added => 1, :code_removed => 10,
										 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		list += c

		java = LocDelta.new('java', :code_added => 100, :code_removed => 1000,
										 :comments_added => 200, :comments_removed => 2000, :blanks_added => 300, :blanks_removed => 3000)
		list += java

		assert list.loc_deltas.include?(c)
		assert list.loc_deltas.include?(java)
		assert list.languages.include?('c')
		assert list.languages.include?('java')

		assert_equal 101, list.code_added
		assert_equal 1010, list.code_removed
		assert_equal 202, list.comments_added
		assert_equal 2020, list.comments_removed
		assert_equal 303, list.blanks_added
		assert_equal 3030, list.blanks_removed
	end

	def test_add_same_language_twice
		list = LocDeltaList.new

		c1 = LocDelta.new('c', :code_added => 1, :code_removed => 10,
										 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		list += c1

		c2 = LocDelta.new('c', :code_added => 100, :code_removed => 1000,
										 :comments_added => 200, :comments_removed => 2000, :blanks_added => 300, :blanks_removed => 3000)
		list += c2

		assert_equal 1, list.loc_deltas.size
		assert list.languages.include?('c')

		assert_equal 101, list.code_added
		assert_equal 1010, list.code_removed
		assert_equal 202, list.comments_added
		assert_equal 2020, list.comments_removed
		assert_equal 303, list.blanks_added
		assert_equal 3030, list.blanks_removed
	end

	def test_net_total
		list = LocDeltaList.new

		c = LocDelta.new('c', :code_added => 1, :code_removed => 10,
										 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		java = LocDelta.new('java', :code_added => 100, :code_removed => 1000,
										 :comments_added => 200, :comments_removed => 2000, :blanks_added => 300, :blanks_removed => 3000)

		list.loc_deltas = [c,java]

		assert_equal 1-10+100-1000, list.net_code
		assert_equal 2-20+200-2000, list.net_comments
		assert_equal 3-30+300-3000, list.net_blanks
		assert_equal 6-60+600-6000, list.net_total
	end

	def test_compact
		list = LocDeltaList.new

		c = LocDelta.new('c', :code_added => 1, :code_removed => 10,
										 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		ruby = LocDelta.new('ruby', :code_added => 1, :code_removed => 1,
										 :comments_added => 0, :comments_removed => 0, :blanks_added => 0, :blanks_removed => 0)
		java = LocDelta.new('java', :code_added => 0, :code_removed => 0,
										 :comments_added => 0, :comments_removed => 0, :blanks_added => 0, :blanks_removed => 0)

		list.loc_deltas = [c,ruby,java]

		assert_equal [c,ruby], list.compact.loc_deltas
	end

	def test_equals
		c1 = LocDelta.new('c', :code_added => 1, :code_removed => 10,
										 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		c2 = LocDelta.new('c', :code_added => 1, :code_removed => 10,
										 :comments_added => 2, :comments_removed => 20, :blanks_added => 3, :blanks_removed => 30)
		assert_equal c1, c2
	end

end
