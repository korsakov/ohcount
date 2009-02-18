require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class LocListTest < Ohcount::Test
	def test_loc_list_default
		list = LocList.new
		assert_equal [], list.locs
		assert_equal [], list.languages
	end

	def test_loc_selector
		list = LocList.new
		c = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		java = Loc.new('java', :code => 10, :comments => 20, :blanks => 30)

		list.locs = [c, java]

		assert_equal c, list.loc('c')
		assert_equal java, list.loc('java')
	end

	def test_method_missing
		list = LocList.new
		c = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		java = Loc.new('java', :code => 10, :comments => 20, :blanks => 30)

		list.locs = [c, java]

		assert_equal c, list.c
		assert_equal java, list.java
	end

	def test_first_add
		list = LocList.new
		loc = Loc.new('c', :code => 1, :comments => 2, :blanks => 3, :filecount => 4)
		list += loc

		assert_equal [loc], list.locs
		assert_equal ['c'], list.languages
		assert_equal 1, list.code
		assert_equal 2, list.comments
		assert_equal 3, list.blanks
		assert_equal 4, list.filecount
	end

	def test_add_two_languages
		list = LocList.new

		c = Loc.new('c', :code => 1, :comments => 2, :blanks => 3, :filecount => 4)
		list += c

		java = Loc.new('java', :code => 10, :comments => 20, :blanks => 30, :filecount => 40)
		list += java

		assert list.locs.include?(c)
		assert list.locs.include?(java)
		assert list.languages.include?('c')
		assert list.languages.include?('java')

		assert_equal 11, list.code
		assert_equal 22, list.comments
		assert_equal 33, list.blanks
		assert_equal 66, list.total
		assert_equal 44, list.filecount
	end

	def test_add_same_language_twice
		list = LocList.new

		c1 = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		list += c1

		c2 = Loc.new('c', :code => 10, :comments => 20, :blanks => 30)
		list += c2

		assert_equal 1, list.locs.size
		assert list.languages.include?('c')

		assert_equal 11, list.code
		assert_equal 22, list.comments
		assert_equal 33, list.blanks
		assert_equal 66, list.total
	end

	def test_add_loc_lists
		list1 = LocList.new + Loc.new('c', :code => 1) + Loc.new('java', :code => 2)
		list2 = LocList.new + Loc.new('c', :code => 10) + Loc.new('ruby', :code => 3)

		sum = list1 + list2

		assert_equal ['c','java','ruby'], sum.languages.sort
		assert_equal 11, sum.loc('c').code
		assert_equal 2, sum.loc('java').code
		assert_equal 3, sum.loc('ruby').code
		assert_equal 16, sum.code
	end

	def test_add_loc_delta
		list = LocList.new

		delta = LocDelta.new('c', :code_added => 1, :code_removed => 0,
											:comments_added => 2, :comments_removed => 0,
											:blanks_added => 3, :blanks_removed => 0)
		list += delta

		assert_equal 1, list.locs.size
		assert_equal 1, list.loc('c').code
		assert_equal 2, list.loc('c').comments
		assert_equal 3, list.loc('c').blanks

		delta = LocDelta.new('c', :code_added => 10, :code_removed => 3,
											:comments_added => 20, :comments_removed => 6,
											:blanks_added => 30, :blanks_removed => 9)
		list += delta

		assert_equal 1, list.locs.size
		assert_equal 8, list.loc('c').code
		assert_equal 16, list.loc('c').comments
		assert_equal 24, list.loc('c').blanks
	end

	def test_add_loc_delta_list
		list = LocList.new

		c = LocDelta.new('c', :code_added => 10, :code_removed => 1, :comments_added => 20, :comments_removed => 2)
		java = LocDelta.new('java', :code_added => 30, :code_removed => 3, :comments_added => 40, :comments_removed => 4)

		delta_list = LocDeltaList.new + c + java

		list += delta_list

		assert_equal 2, list.locs.size

		assert_equal 9, list.loc('c').code
		assert_equal 18, list.loc('c').comments

		assert_equal 27, list.loc('java').code
		assert_equal 36, list.loc('java').comments
	end

	def test_compact
		list = LocList.new
		c = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		java = Loc.new('java', :code => 0, :comments => 0, :blanks => 0)
		list.locs = [c, java]

		assert_equal [c], list.compact.locs
	end
end
