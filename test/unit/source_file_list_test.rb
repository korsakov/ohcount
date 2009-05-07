require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class SourceFileListTest < Ohcount::Test

	def test_language_facts
		sfl = SourceFileList.new(:path => test_dir('win32_enough'))
		sfl.analyze(:language)
		assert_equal 2, sfl.loc_list.filecount
		assert_equal 2, sfl.loc_list.c.code
		assert_equal 2, sfl.loc_list.c.comments
		assert_equal 2, sfl.loc_list.c.blanks
	end

	protected

	def license_file(f)
		File.expand_path(File.dirname(__FILE__) + "/../src_licenses/#{ f }")
	end

	def test_dir(d)
		File.expand_path(File.dirname(__FILE__) + "/../gestalt_files/#{ d }")
	end

end

