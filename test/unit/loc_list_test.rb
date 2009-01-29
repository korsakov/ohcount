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

	def test_first_add
		list = LocList.new
		loc = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		list += loc

		assert_equal [loc], list.locs
		assert_equal ['c'], list.languages
		assert_equal 1, list.code
		assert_equal 2, list.comments
		assert_equal 3, list.blanks
	end

	def test_add_two_languages
		list = LocList.new

		c = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		list += c

		java = Loc.new('java', :code => 10, :comments => 20, :blanks => 30)
		list += java

		assert list.locs.include?(c)
		assert list.locs.include?(java)
		assert list.languages.include?('c')
		assert list.languages.include?('java')

		assert_equal 11, list.code
		assert_equal 22, list.comments
		assert_equal 33, list.blanks
		assert_equal 66, list.total
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

	def test_compact
		list = LocList.new
		c = Loc.new('c', :code => 1, :comments => 2, :blanks => 3)
		java = Loc.new('java', :code => 0, :comments => 0, :blanks => 0)
		list.locs = [c, java]

		assert_equal [c], list.compact.locs
	end
end
