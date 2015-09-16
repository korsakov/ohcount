require 'test/unit'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

include Ohcount
include Ohcount::Gestalt

class DefinitionsTest < Ohcount::Test

	def test_zend_framework
		assert_gestalts 'zend_framework', [
      Base.new(:platform,'php'),
      Base.new(:platform,'zendframework'),
			Base.new(:platform,'scripting')
    ]
	end

	def test_php
		assert_gestalts 'php', [
      Base.new(:platform,'php'),
			Base.new(:platform,'scripting')
    ]
	end

	def test_wx_widgets
		assert_gestalts 'wx_widgets', [
      Base.new(:platform,'wxwidgets'),
      Base.new(:platform, 'native_code')
    ]
	end

	def test_eclipse_platform
		assert_gestalts 'eclipse_platform', [
      Base.new(:platform,'java'),
      Base.new(:platform,'eclipseplatform')
    ]
	end

	def test_win32_not_enough
		assert_gestalts 'win32_not_enough', [
      Base.new(:platform, 'native_code')
		]
	end

	def test_win32_enough
		assert_gestalts 'win32_enough', [
      Base.new(:platform, 'win32'),
      Base.new(:platform, 'native_code')
    ]
	end

	def test_ruby_just_enough
		assert_gestalts 'ruby_just_enough', [
      Base.new(:platform, 'ruby'),
      Base.new(:platform, 'scripting'),
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
      Base.new(:platform, 'php'),
      Base.new(:platform, 'cakephp'),
      Base.new(:platform, 'scripting'),
    ]
	end

	def test_symfony
		assert_platform('symfony', :php, :symfony, :scripting)
	end

	def test_pear
		assert_platform('pear', :php, :pear, :scripting)
	end

	def test_moodle
		assert_platform('moodle', :php, :moodle, :scripting)
	end

	def test_spring_framework
		assert_gestalts 'spring_framework', [
      Base.new(:platform, 'java'),
      Base.new(:platform, 'springframework')
    ]
	end

	def test_rails
		assert_platform('rails', :ruby, :rails, :scripting)
	end

	def test_jquery
		assert_platform('jquery', :javascript, :jquery, :scripting)
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
		assert_platform('python', :python, :scripting)
	end

	def test_mac
		assert_platform('mac', :mac, :native_code)
	end

	def test_plist
		assert_platform('plist', :mac)
	end

	def test_posix
		assert_platform('posix', :posix, :native_code)
	end

	def test_x_windows
		assert_platform('xwindows', :xwindows, :native_code)
	end

	def test_kde
		assert_platform('kde', :kde, :native_code)
	end

	def test_msdos
		assert_platform('msdos', :msdos, :native_code)
	end

	def test_gtk
		assert_platform('gtk', :gtk, :native_code)
	end

	def test_drupal
		assert_platform('drupal', :php, :drupal, :scripting)
	end

	def test_vs_1
		assert_tool('vs_1', :visualstudio)
	end

	def test_eclipse
		assert_tool('eclipse', :eclipse)
	end

	def test_netbeans
		assert_tool('netbeans', :netbeans)
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

	def test_moblin_clutter
		c = SourceFile.new("foo.c", :contents => <<-INLINE_C
			  clutter_actor_queue_redraw (CLUTTER_ACTOR(label));
			INLINE_C
		)
    expected_gestalts = [
      Base.new(:platform, 'clutter'),
      Base.new(:platform, 'moblin'),
      Base.new(:platform, 'mid_combined'),
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
      Base.new(:platform, 'moblin_misc'),
      Base.new(:platform, 'moblin'),
      Base.new(:platform, 'mid_combined'),
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
      Base.new(:platform, 'moblin_misc'),
      Base.new(:platform, 'moblin'),
      Base.new(:platform, 'mid_combined'),
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
			Base.new(:platform, 'mid_combined'),
      Base.new(:platform, 'moblin'),
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

		names = java.gestalts.map { |g| g.name if g.type == :platform }.compact
		assert names.include?('java')
		assert names.include?('android')
		assert names.include?('mid_combined')
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
      Base.new(:platform, 'iphone'),
      Base.new(:platform, 'mid_combined')
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
      Base.new(:platform, 'mid_combined')
    ]

    assert_equal expected_gestalts.sort, c.gestalts.sort
	end

	def test_atom_linux
		make = SourceFile.new("makefile", :contents => <<-INLINE_MAKEFILE
			COMPILE_FLAGS=/QxL
		INLINE_MAKEFILE
    )
		expected_gestalts = [
      Base.new(:platform, 'xl_flag'),
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
      Base.new(:platform, 'xl_flag'),
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
		platforms = java.gestalts.map { |g| g.name if g.type == :platform }.compact
		assert platforms.include?('java')
		assert platforms.include?('opensso')
	end

	def test_windows_ce
		csharp = SourceFile.new("bam.cs", :contents => <<-INLINE_CSHARP
				using System;
				using Microsoft.WindowsMobile.DirectX;
			INLINE_CSHARP
		)
    expected_gestalts = [
      Base.new(:platform, 'windows_ce_incomplete'),
      Base.new(:platform, 'dot_net'),
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
