require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::DiffTest < Ohcount::Test

	def test_one
		src_dir    = File.dirname(__FILE__) + '/../src_dir/'
		sloc_infos = Ohcount.diff_files(src_dir + 'diff1_old.html', src_dir + 'diff1_new.html')

		css = Ohcount::SlocInfo.new('css')
		css.code_added = 1
		css.comments_added = 1

		html = Ohcount::SlocInfo.new('html')
		html.code_added, html.code_removed = [1,1]

		js = Ohcount::SlocInfo.new('javascript')
		js.code_removed = 1
		js.comments_removed = 1

		assert_equal [css, html, js], sloc_infos
	end

	def test_two
		src_dir = File.dirname(__FILE__) + '/../src_dir/'
		sloc_infos = Ohcount.diff_files(src_dir + 'diff2_old.c', src_dir + 'diff2_new.c')

		c = Ohcount::SlocInfo.new('c')
		c.code_added,     c.code_removed     = [1,1]
		c.comments_added, c.comments_removed = [1,1]

		assert_equal [c], sloc_infos
	end

	def test_three
		src_dir = File.dirname(__FILE__) + '/../src_dir/'
		sloc_infos = Ohcount.diff_files(src_dir + 'diff3_old.xml', src_dir + 'diff3_new.xml')

		xml = Ohcount::SlocInfo.new('xml')
		xml.code_added, xml.code_removed = [1,1]

		assert_equal [xml], sloc_infos
	end
end
