require File.dirname(__FILE__) + '/../../test_helper'

include Ohcount
include Ohcount::Gestalt

class PlatformTest < Test::Unit::TestCase

	def test_initialize
		b = Ohcount::Gestalt::Base.new(:dir => gestalt_file_dir('test_cakephp'))
		assert_equal [gestalt_file_dir('test_cakephp/foo.php')], b.filenames
	end

	def test_win32_not_enough
		b = Ohcount::Gestalt::Base.new(:dir => gestalt_file_dir('test_win32_not_enough'))
		b.process!
		assert_equal [], b.platforms
	end

	def test_win32_enough
		b = Ohcount::Gestalt::Base.new(:dir => gestalt_file_dir('test_win32_enough'))
		b.process!
		assert_equal [Win32], b.platforms
	end

	def test_linux_1
		b = Ohcount::Gestalt::Base.new(:dir => gestalt_file_dir('test_linux_1'))
		b.process!
		assert_equal [POSIX, Linux], b.platforms
	end

	def test_ruby_just_enough
		b = Ohcount::Gestalt::Base.new(:dir => gestalt_file_dir('test_ruby_just_enough'))
		b.process!
		assert_equal [Ruby], b.platforms
	end

	def test_ruby_not_enough
		assert_platform('test_ruby_not_enough')
	end

	def test_cakephp
		assert_platform('test_cakephp', CakePHP)
	end

	protected

	def assert_platform(path, *platforms)
		b = Ohcount::Gestalt::Base.new(:dir => gestalt_file_dir(path))
		b.process!
		assert_equal platforms, b.platforms
	end

	def gestalt_file_dir(path = '')
		File.expand_path(File.dirname(__FILE__) + "/../../gestalt_files/" + path)
	end
end
