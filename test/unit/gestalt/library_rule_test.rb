require File.dirname(__FILE__) + '/../../test_helper'

class LibraryRuleTest < Test::Unit::TestCase

	def test_trigger_c_header
		r = Ohcount::Gestalt::CHeaderRule.new('foo.h')
		s = Ohcount::SourceFile.new('header.h', :contents => <<-H_FILE
			// a comment
			include 'foo.h'
			H_FILE
		)
		assert r.trigger?(s)
	end

	def test_c_keyword_rule
		r = Ohcount::Gestalt::CKeywordRule.new('WM_PAINT')
		s = Ohcount::SourceFile.new('header.h', :contents => <<-H_FILE
			// a comment
			(WM_PAINT)
			H_FILE
		)
		assert r.trigger?(s)
	end

	def test_file_rule
		r = Ohcount::Gestalt::FileRule.new('header.h')
		s = Ohcount::SourceFile.new('header.h')
		assert r.trigger?(s)
	end
end


