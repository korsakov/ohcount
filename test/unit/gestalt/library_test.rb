require File.dirname(__FILE__) + '/../../test_helper'

include Ohcount
include Ohcount::Gestalt

class TestLibrary < Ohcount::Gestalt::Library
	c_headers "foobar.h"
end

class LibraryTest < Test::Unit::TestCase
	def test_descendants
		assert Library.descendants.include?(TestLibrary)
	end

	def test_gnulib
		s = SourceFile.new("foo.h", :filenames => [], :contents => <<-INLINE_C
											 include <xstrtol.h>;
											 INLINE_C
											)
		assert_detected_lib(s, GnuLib, CHeaderRule)

		s = SourceFile.new("foo.h", :filenames => [], :contents => <<-INLINE_C
											 include 'diacrit.h';
											 INLINE_C
											)
		assert_detected_lib(s, GnuLib, CHeaderRule)
	end

	def test_windows_constants
		s = SourceFile.new("foo.c", :filenames => [], :contents => <<-INLINE_C
											 wc.lpfnWndProc          = (WNDPROC) WndProc;
											 INLINE_C
											)
		assert_detected_lib(s, WindowsConstants, CKeywordRule)
	end

	def test_apple_events
		s = SourceFile.new("foo.c", :filenames => [], :contents => <<-INLINE_C
											 // fake apple event file
											 AppleEvent tAppleEvent;
											 INLINE_C
											)
		assert_detected_lib(s, AppleEvents, CKeywordRule)
	end

	def test_xwindows
		s = SourceFile.new("foo.c", :filenames => [], :contents => <<-INLINE_C
											 #include <X11/xpm.h>
											 INLINE_C
											)
		assert_detected_lib(s, XWindowsLib, CHeaderRule)
	end

	def test_kde
		s = SourceFile.new("foo.c", :filenames => [], :contents => <<-INLINE_C
											 #include <kdeversion.h>
											 INLINE_C
											)
		assert_detected_lib(s, KDEHeaders, CHeaderRule)
	end


	protected

	def assert_detected_lib(source_file, lib, triggered_rule)
		libs = Ohcount::Gestalt::Library.detect_libraries(source_file)
		assert_equal 1, libs.size
		assert_equal lib, libs[0].class

		assert_equal 1, libs[0].triggered_rules.size
		assert_equal triggered_rule, libs[0].triggered_rules[0].class
	end
end
