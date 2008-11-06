require File.dirname(__FILE__) + '/../../test_helper'

include Ohcount
include Ohcount::Gestalt

class PlatformTest < Test::Unit::TestCase

	def test_win32_not_enough
		assert_platform('test_win32_not_enough')
	end

	def test_win32_enough
		assert_platform('test_win32_enough', Win32)
	end

	def test_linux_1
		assert_platform('test_linux_1', POSIX, Linux)
	end

	def test_ruby_just_enough
		assert_platform('test_ruby_just_enough', Ruby)
	end

	def test_ruby_not_enough
		assert_platform('test_ruby_not_enough')
	end

	def test_cakephp
		assert_platform('test_cakephp', CakePHP)
	end

	protected

	def assert_platform(path, *platforms)
		sfl = SourceFileList.new(:path => test_dir(path))
		sfl.analyze(:gestalt)
		assert_equal platforms, sfl.gestalt_facts.platforms
	end

	def test_dir(d)
		File.expand_path(File.dirname(__FILE__) + "/../../gestalt_files/#{ d }")
	end
end
