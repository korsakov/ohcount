require 'test/unit'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

include Ohcount
include Ohcount::Gestalt

class DefinitionsTest < Ohcount::Test

	def test_zend_framework
		assert_gestalts 'zend_framework', [
      Base.new(:platform,'PHP'),
      Base.new(:platform,'ZendFramework'),
			Base.new(:platform,'Scripting')
    ]
	end

	def test_php
		assert_gestalts 'php', [
      Base.new(:platform,'PHP'),
			Base.new(:platform,'Scripting')
    ]
	end

	def test_wx_widgets
		assert_gestalts 'wx_widgets', [
      Base.new(:platform,'WxWidgets'),
      Base.new(:platform, 'native_code')
    ]
	end

	def test_eclipse_platform
		assert_gestalts 'eclipse_platform', [
      Base.new(:platform,'Java'),
      Base.new(:platform,'EclipsePlatform'),
      Base.new(:java_import,"java.text.SimpleDateFormat"),
      Base.new(:java_import,"java.util.Map"),
      Base.new(:java_import,"org.eclipse.core")
    ]
	end

	def test_win32_not_enough
		assert_gestalts 'win32_not_enough', [
      Base.new(:platform, 'native_code')
		]
	end

	def test_win32_enough
		assert_gestalts 'win32_enough', [
      Base.new(:platform, 'Win32'),
      Base.new(:platform, 'native_code')
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
      Base.new(:platform, 'Ruby'),
      Base.new(:platform, 'Scripting'),
      Base.new(:platform, 'native_code'),
    ]
	end

	def test_ruby_not_enough
		assert_gestalts 'ruby_not_enough', [
			Base.new(:platform, 'native_code')
		]
	end

	def test_cakephp
		assert_gestalts 'cakephp', [
      Base.new(:platform, 'PHP'),
      Base.new(:platform, 'CakePHP'),
      Base.new(:platform, 'Scripting'),
    ]
	end

	def test_symfony
		assert_platform('symfony', :PHP, :Symfony, :Scripting)
	end

	def test_pear
		assert_platform('pear', :PHP, :Pear, :Scripting)
	end

	def test_moodle
		assert_platform('moodle', :PHP, :Moodle, :Scripting)
	end

	def test_spring_framework
		assert_gestalts 'spring_framework', [
      Base.new(:platform, 'Java'),
      Base.new(:platform, 'SpringFramework'),
      Base.new(:java_jar, 'spring.jar'),
    ]
	end

	def test_rails
		assert_platform('rails', :Ruby, :Rails, :Scripting)
	end

	def test_jquery
		assert_platform('jquery', :Javascript, :JQuery, :Scripting)
	end

	def test_dojo
		h = SourceFile.new("sample.html", :contents => '<SCRIPT TYPE="text/javascript" SRC="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dojo/dojo.xd.js"></SCRIPT>')
		expected_gestalts = [ Base.new(:platform, "dojo") ]
		assert_equal expected_gestalts.sort, h.gestalts.sort
	end

	def test_yui
		h = SourceFile.new("sample.html", :contents => '<script type="text/javascript" src="http://yui.yahooapis.com/2.7.0/build/yahoo/yahoo-min.js" ></script>')
		expected_gestalts = [ Base.new(:platform, "yui") ]
		assert_equal expected_gestalts.sort, h.gestalts.sort
	end

	def test_python
		assert_platform('python', :Python, :Scripting)
	end

	def test_mac
		assert_platform('mac', :Mac, :native_code)
	end

	def test_plist
		assert_platform('plist', :Mac)
	end

	def test_posix
		assert_platform('posix', :POSIX, :native_code)
	end

	def test_x_windows
		assert_platform('xwindows', :XWindows, :native_code)
	end

	def test_kde
		assert_platform('kde', :KDE, :native_code)
	end

	def test_msdos
		assert_platform('msdos', :MSDos, :native_code)
	end

	def test_gtk
		assert_platform('gtk', :GTK, :native_code)
	end

	def test_drupal
		assert_platform('drupal', :PHP, :Drupal, :Scripting)
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

	def test_arm
    asm = SourceFile.new("foo.S", :contents => <<-INLINE_ASM
			orrs 3, eax
      INLINE_ASM
    )

		expected_gestalts = [
			Base.new(:platform, 'arm')
		]

		assert_equal expected_gestalts.sort, asm.gestalts.sort
	end

	def test_arm_from_c_keywords
		c = SourceFile.new("foo.c", :contents => <<-INLINE_C
      #define __arm__
		INLINE_C
    )
		expected_gestalts = [
      Base.new(:platform, 'arm'),
      Base.new(:platform, 'native_code')
		]
		assert_equal expected_gestalts, c.gestalts
	end

	def test_arm_neon
    asm = SourceFile.new("foo.S", :contents => <<-INLINE_ASM
			vmov u8, s
      INLINE_ASM
    )

    expected_gestalts = [
      Base.new(:platform, 'arm'),
      Base.new(:platform, 'arm_neon')
    ]

    assert_equal expected_gestalts.sort, asm.gestalts.sort
	end

	def test_imports_from_java_file
    jar = SourceFile.new("foo/foo.jar", :contents => '')

    expected_gestalts = [
      Base.new(:java_jar, 'foo.jar'),
    ]

    assert_equal expected_gestalts.sort, jar.gestalts.sort
	end

	def test_moblin_clutter
		c = SourceFile.new("foo.c", :contents => <<-INLINE_C
			  clutter_actor_queue_redraw (CLUTTER_ACTOR(label));
			INLINE_C
		)
    expected_gestalts = [
      Base.new(:platform, 'clutter'),
      Base.new(:platform, 'moblin_all'),
      Base.new(:platform, 'MID_combined'),
      Base.new(:platform, 'native_code')
    ]

    assert_equal expected_gestalts.sort, c.gestalts.sort
	end

	def test_moblin_by_filename
		c = SourceFile.new("moblin-netbook-system-tray.h", :contents => <<-INLINE_PERL
				#include "foo"
			INLINE_PERL
		)
    expected_gestalts = [
      Base.new(:platform, 'moblin'),
      Base.new(:platform, 'moblin_all'),
      Base.new(:platform, 'MID_combined'),
      Base.new(:platform, 'native_code')
    ]

    assert_equal expected_gestalts.sort, c.gestalts.sort
	end

	def test_moblin_by_keyword
		c = SourceFile.new("foo.c", :contents => <<-INLINE_PERL
				proxy = dbus_g_proxy_new_for_name (conn, "org.moblin.connman",
			INLINE_PERL
		)
    expected_gestalts = [
      Base.new(:platform, 'moblin'),
      Base.new(:platform, 'moblin_all'),
      Base.new(:platform, 'MID_combined'),
      Base.new(:platform, 'native_code')
    ]

    assert_equal expected_gestalts.sort, c.gestalts.sort
	end

	def test_nbtk
		c = SourceFile.new("foo.c", :contents => <<-INLINE_C
				button = nbtk_button_new_with_label ("Back");
			INLINE_C
		)
    expected_gestalts = [
      Base.new(:platform, 'nbtk'),
			Base.new(:platform, 'MID_combined'),
      Base.new(:platform, 'moblin_all'),
      Base.new(:platform, 'native_code')
    ]

    assert_equal expected_gestalts.sort, c.gestalts.sort
	end


	def test_android
    java = SourceFile.new("foo.java", :contents => <<-INLINE_C
			import android.app.Activity;
			// import dont.import.this;
      INLINE_C
    )

    expected_gestalts = [
      Base.new(:java_import, 'android.app.Activity'),
      Base.new(:platform,    'Java'),
      Base.new(:platform,    'android'),
      Base.new(:platform,    'MID_combined')
    ]

    assert_equal expected_gestalts.sort, java.gestalts.sort
	end

	def test_iphone
    objective_c = SourceFile.new("foo.m", :contents => <<-OBJECTIVE_C
			 #import <Foundation/Foundation.h>
			 #import <UIKit/UIKit.h>
			 #import "WhackABugApp.h"

			 int main(int argc, char *argv[]) {
				 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				 int ret = UIApplicationMain(argc, argv, [WhackABugApp class]);
				 [pool release];
				 return ret;
			 }
      OBJECTIVE_C
    )

    expected_gestalts = [
      Base.new(:platform, 'iPhone'),
      Base.new(:platform, 'MID_combined')
    ]

    assert_equal expected_gestalts.sort, objective_c.gestalts.sort
	end

	def test_hildon
		c = SourceFile.new("foo.c", :contents => <<-INLINE_C
				HildonWindow *window;
			INLINE_C
		)
    expected_gestalts = [
      Base.new(:platform, 'hildon'),
      Base.new(:platform, 'maemo'),
      Base.new(:platform, 'native_code'),
      Base.new(:platform, 'MID_combined')
    ]

    assert_equal expected_gestalts.sort, c.gestalts.sort
	end

	def test_atom_linux
		make = SourceFile.new("makefile", :contents => <<-INLINE_MAKEFILE
			COMPILE_FLAGS=/QxL
		INLINE_MAKEFILE
    )
		expected_gestalts = [
      Base.new(:platform, 'xL_flag'),
      Base.new(:platform, 'atom')
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
	end

	def test_atom_windows
		make = SourceFile.new("makefile", :contents => <<-INLINE_MAKEFILE
			CCFLAGS = -xL
		INLINE_MAKEFILE
    )
		expected_gestalts = [
      Base.new(:platform, 'xL_flag'),
      Base.new(:platform, 'atom')
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
	end

	def test_not_atom_windows
		make = SourceFile.new("makefile", :contents => <<-INLINE_MAKEFILE
			CCFLAGS = -xLo
		INLINE_MAKEFILE
    )
		expected_gestalts = []
		assert_equal expected_gestalts.sort, make.gestalts.sort
	end

	def test_atom_sse3
		make = SourceFile.new("makefile", :contents => <<-INLINE_MAKEFILE
			COMPILE_FLAGS=-xSSE3_ATOM_FLAG
		INLINE_MAKEFILE
    )
		expected_gestalts = [
      Base.new(:platform, 'sse3_atom_flag'),
      Base.new(:platform, 'atom')
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
	end

	def test_intel_compiler

		make = SourceFile.new("Makefile", :contents => <<-INLINE_MAKEFILE
			CC = icc
		INLINE_MAKEFILE
    )
		expected_gestalts = [
      Base.new(:platform, 'intel_compiler'),
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
	end

	def test_opensso
		java = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
import com.sun.identity.authentication;
			INLINE_JAVA
		)
    expected_gestalts = [
      Base.new(:platform, 'Java'),
      Base.new(:platform, 'OpenSSO'),
      Base.new(:java_import, 'com.sun.identity')
    ]

    assert_equal expected_gestalts.sort, java.gestalts.sort
	end

	def test_windows_ce
		csharp = SourceFile.new("bam.cs", :contents => <<-INLINE_CSHARP
				using System;
				using Microsoft.WindowsMobile.DirectX;
			INLINE_CSHARP
		)
    expected_gestalts = [
      Base.new(:platform, 'windows_ce_incomplete'),
      Base.new(:platform, 'Dot_NET'),
    ]

		assert_equal expected_gestalts.sort, csharp.gestalts.sort
	end

	def test_gcc
		make = SourceFile.new("Makefile", :contents => <<-INLINE_MAKEFILE
			CC = gcc
		INLINE_MAKEFILE
    )
		expected_gestalts = [
      Base.new(:platform, 'gcc'),
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
	end

	def test_native_code
		c = SourceFile.new("foo.c", :contents => <<-INLINE_C
			int *pcode = NULL;
		INLINE_C
    )
		expected_gestalts = [
      Base.new(:platform, 'native_code'),
		]
		assert_equal expected_gestalts.sort, c.gestalts.sort
	end

  def test_jasper_jr
		make = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
      public class Employee implements Serializable {
        private net.sf.jasperreports.report myReport;
      }
		INLINE_JAVA
    )
		expected_gestalts = [
      Base.new(:platform, 'jasper_jr'),
      Base.new(:platform, 'Java'),
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
  end

  def test_jasper_jr_pom
		make = SourceFile.new("pom.xml", :contents => <<-INLINE_POM
        <project>
          <groupId>dzrealms</groupId>
          <artifactId>HelloWorld</artifactId>
          <version>1.0</version>
          <dependencies>
            <dependency>
              <groupId>jgoodies</groupId>
              <artifactId>plastic</artifactId>
              <version>1.2.0</version>
            </dependency>
            <dependency>
              <groupId>log4j</groupId>
              <artifactId>log4j</artifactId>
              <version>1.2.8</version>
            </dependency>
            <dependency>
              <groupId>jasperreports</groupId>
              <artifactId>jasperreports</artifactId>
              <version>2.0.5</version>
            </dependency>
          </dependencies>
          <build>
            <sourceDirectory>src/main/java</sourceDirectory>
            <unitTestSourceDirectory>src/test/java</unitTestSourceDirectory>
            <unitTest>
              <includes>
                <include>**/*Test.java</include>
              </includes>
            </unitTest>
          </build>
        </project>
    INLINE_POM
    )
		expected_gestalts = [
      Base.new(:platform, 'jasper_jr'),
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
  end

  def test_jasper_jsce
		make = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
      public class Employee implements Serializable {
        private com.jaspersoft.jasperserver;
      }
		INLINE_JAVA
    )
		expected_gestalts = [
      Base.new(:platform, 'Java'),
      Base.new(:platform, 'jasper_jsce')
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
  end

  def test_jasper_ji
		make = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
      public class Employee implements Serializable {
        private com.jaspersoft.ji;
      }
		INLINE_JAVA
    )
		expected_gestalts = [
      Base.new(:platform, 'Java'),
      Base.new(:platform, 'jasper_ji')
		]
		assert_equal expected_gestalts.sort, make.gestalts.sort
  end

	def test_flash
		as = SourceFile.new("sample.as", :contents => 'greet.text = "Hello, world";')
		expected_gestalts = [ Base.new(:platform, "flash") ]
		assert_equal expected_gestalts.sort, as.gestalts.sort
	end

	def test_flex
		as = SourceFile.new("sample.mxml", :contents => <<-MXML
			<?xml version="1.0" encoding="utf-8"?>
			<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"></mx:Application>
		MXML
		)
		expected_gestalts = [ Base.new(:platform, 'flex') ]
		assert_equal expected_gestalts.sort, as.gestalts.sort
	end
end
