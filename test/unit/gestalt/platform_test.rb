require File.dirname(__FILE__) + '/../../test_helper'

include Ohcount
include Ohcount::Gestalt

class PlatformTest < Test::Unit::TestCase

	def test_wx_widgets
		assert_platform('wx_widgets', WxWidgets)
	end

	def test_eclipse_platform
		assert_platform('eclipse_platform', Java, EclipsePlatform)
	end

	def test_win32_not_enough
		assert_platform('win32_not_enough')
	end

	def test_win32_enough
		assert_platform('win32_enough', Win32)
	end

	def test_wpf
		assert_platform('wpf', WPF)
	end

	def test_asp_net
		assert_platform('asp_net', ASP_NET)
	end

	def test_ruby_just_enough
		assert_platform('ruby_just_enough', Ruby)
	end

	def test_ruby_not_enough
		assert_platform('ruby_not_enough')
	end

	def test_cakephp
		assert_platform('cakephp', PHP, CakePHP)
	end

	def test_symfony
		assert_platform('symfony', PHP, Symfony)
	end

	def test_spring_framework
		assert_platform('spring_framework', Java, SpringFramework)
	end

	def test_rails
		assert_platform('rails', Ruby, Rails)
	end

	def test_jquery
		assert_platform('jquery', Javascript, JQuery)
	end

	def test_php
		assert_platform('php', PHP)
	end

	def test_mac
		assert_platform('mac', Mac)
	end

	def test_plist
		assert_platform('plist', Mac)
	end

	def test_posix
		assert_platform('posix', POSIX)
	end

	def test_x_windows
		assert_platform('xwindows', XWindows)
	end

	def test_kde
		assert_platform('kde', KDE)
	end

	def test_msdos
		assert_platform('msdos', MSDos)
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
