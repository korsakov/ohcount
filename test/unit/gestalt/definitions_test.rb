require File.dirname(__FILE__) + '/../../test_helper'

include Ohcount
include Ohcount::Gestalt

class PlatformTest < Test::Unit::TestCase

	def test_zend_framework
		assert_gestalts 'zend_framework', [
      Base.new(:platform,'PHP'),
      Base.new(:platform,'ZendFramework')
    ]
	end

	def test_php
		assert_gestalts 'php', [
      Base.new(:platform,'PHP')
    ]
	end

	def test_wx_widgets
		assert_gestalts 'wx_widgets', [
      Base.new(:platform,'WxWidgets')
    ]
	end

	def test_eclipse_platform
		assert_gestalts 'eclipse_platform', [
      Base.new(:platform,'Java'),
      Base.new(:platform,'EclipsePlatform'),
      Base.new(:java_import,"java.text.SimpleDateFormat"),
      Base.new(:java_import,"java.util.Map"),
      Base.new(:java_import,"org.eclipse.core.lotsa_stuff")
    ]
	end

	def test_win32_not_enough
		assert_gestalts 'win32_not_enough', []
	end

	def test_win32_enough
		assert_gestalts 'win32_enough', [
      Base.new(:platform, 'Win32')
    ]
	end

	def test_wpf
		assert_gestalts 'wpf', [
      Base.new(:platform, 'WPF')
    ]
	end

	def test_asp_net
		assert_gestalts 'asp_net', [
      Base.new(:platform, 'ASP_NET')
    ]
	end

	def test_ruby_just_enough
		assert_gestalts 'ruby_just_enough', [
      Base.new(:platform, 'Ruby')
    ]
	end

	def test_ruby_not_enough
		assert_gestalts 'ruby_not_enough', []
	end

	def test_cakephp
		assert_gestalts 'cakephp', [
      Base.new(:platform, 'PHP'),
      Base.new(:platform, 'CakePHP')
    ]
	end

	def test_symfony
		assert_platform('symfony', :PHP, :Symfony)
	end

	def test_pear
		assert_platform('pear', :PHP, :Pear)
	end

	def test_moodle
		assert_platform('moodle', :PHP, :Moodle)
	end

	def test_spring_framework
		assert_gestalts 'spring_framework', [
      Base.new(:platform, 'Java'),
      Base.new(:platform, 'SpringFramework'),
      Base.new(:java_jar, 'spring.jar'),
    ]
	end

	def test_rails
		assert_platform('rails', :Ruby, :Rails)
	end

	def test_jquery
		assert_platform('jquery', :Javascript, :JQuery)
	end

	def test_python
		assert_platform('python', :Python)
	end

	def test_mac
		assert_platform('mac', :Mac)
	end

	def test_plist
		assert_platform('plist', :Mac)
	end

	def test_posix
		assert_platform('posix', :POSIX)
	end

	def test_x_windows
		assert_platform('xwindows', :XWindows)
	end

	def test_kde
		assert_platform('kde', :KDE)
	end

	def test_msdos
		assert_platform('msdos', :MSDos)
	end

	def test_gtk
		assert_platform('gtk', :GTK)
	end

	def test_drupal
		assert_platform('drupal', :PHP, :Drupal)
	end

	def test_vs_1
		assert_tool('vs_1', :VisualStudio)
	end

	def test_eclipse
		assert_tool('eclipse', :Eclipse)
	end

	def test_netbeans
		assert_tool('netbeans', :NetBeans)
	end

	def test_java_imports_from_java_file
    java = SourceFile.new("foo.java", :contents => <<-INLINE_C
      import com.foo;
      import net.ohloh;
      import com.foo;
			// import dont.import.this;
      INLINE_C
    )

    expected_gestalts = [
      Base.new(:java_import, 'com.foo', 2),
      Base.new(:java_import, 'net.ohloh'),
      Base.new(:platform,    'Java'),
    ]

    assert_equal expected_gestalts.sort, java.gestalts.sort
	end

	def test_imports_from_java_file
    jar = SourceFile.new("foo/foo.jar", :contents => '')

    expected_gestalts = [
      Base.new(:java_jar, 'foo.jar'),
    ]

    assert_equal expected_gestalts.sort, jar.gestalts.sort
	end

	protected

  def assert_tool(path, *tools)
    gestalts = tools.map do |t|
      Base.new(:tool, t.to_s)
    end
    assert_gestalts path, gestalts
  end

	def assert_platform(path, *platforms)
    gestalts = platforms.map do |p|
      Base.new(:platform, p.to_s)
    end
    assert_gestalts path, gestalts
  end

	def assert_gestalts(path, expected_gestalts)
		sfl = SourceFileList.new(:path => test_dir(path))
		sfl.analyze(:gestalt)
    assert_equal expected_gestalts.sort, sfl.gestalts.sort
  end

	def test_dir(d)
		File.expand_path(File.dirname(__FILE__) + "/../../gestalt_files/#{ d }")
	end
end
