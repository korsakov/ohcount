require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class SourceFileListTest < Ohcount::Test

#	def test_init_with_dir
#		sfl = SourceFileList.new(:dir => test_dir('test_win32_enough'))
#		assert_equal 2, sfl.size
#	end

	def test_language_facts
		sfl = SourceFileList.new(:path => test_dir('win32_enough'))
		sfl.analyze(:language)
		assert_equal 2, sfl.language_facts.filecount
		assert_equal 2, sfl.language_facts.c.code
		assert_equal 2, sfl.language_facts.c.comments
		assert_equal 2, sfl.language_facts.c.blanks
	end

	def test_gestalt_facts
		sfl = SourceFileList.new(:path => test_dir('win32_enough'))
		sfl.analyze(:gestalt)
		assert_equal [Win32], sfl.gestalt_facts.platforms
	end

	protected

	def license_file(f)
		File.expand_path(File.dirname(__FILE__) + "/../src_licenses/#{ f }")
	end

	def test_dir(d)
		File.expand_path(File.dirname(__FILE__) + "/../gestalt_files/#{ d }")
	end

end

