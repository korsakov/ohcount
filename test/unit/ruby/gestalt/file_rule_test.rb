require 'test/unit'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

class FileRuleTest < Test::Unit::TestCase
  include Ohcount::Gestalt

  def test_initialize
    r = FileRule.new(:min => 5)
    assert_equal 5, r.min_count
  end

  def test_initialize_wrong_args
    assert_raise ArgumentError do
      r = FileRule.new(:boo => 1)
    end
  end

#	def test_trigger_c_header
#		r = Ohcount::Gestalt::CHeaderRule.new('foo.h')
#		s = Ohcount::SourceFile.new('header.h', :contents => <<-H_FILE
#			// a comment
#			include 'foo.h'
#			H_FILE
#		)
#		assert r.trigger_file?(s)
#	end
#
#	def test_c_keyword_rule
#		r = Ohcount::Gestalt::CKeywordRule.new('WM_PAINT')
#		s = Ohcount::SourceFile.new('header.h', :contents => <<-H_FILE
#			// a comment
#			(WM_PAINT)
#			H_FILE
#		)
#		assert r.trigger_file?(s)
#	end
#
#	def test_filename_rule
#		r = Ohcount::Gestalt::FilenameRule.new('header.h')
#		s = Ohcount::SourceFile.new('header.h')
#		assert r.trigger_file?(s)
#	end
#
#	def test_filename_rule_advanced
#		r = Ohcount::Gestalt::FilenameRule.new('f[ab]o', 'foo')
#		assert r.trigger_file?(Ohcount::SourceFile.new('fao'))
#		assert r.trigger_file?(Ohcount::SourceFile.new('fbo'))
#		assert r.trigger_file?(Ohcount::SourceFile.new('foo'))
#		assert !r.trigger_file?(Ohcount::SourceFile.new('fco'))
#	end
end



