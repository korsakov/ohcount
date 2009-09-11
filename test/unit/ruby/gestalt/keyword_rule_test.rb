require 'test/unit'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

class KeywordRuleTest < Test::Unit::TestCase
  include Ohcount::Gestalt

	def test_process_file_in_same_language
		r = KeywordRule.new('c', 'WIN32')
		s = Ohcount::SourceFile.new('header.c', :contents => <<-C_CODE
			// a comment
			#ifdef WIN32
      ..some code..
      #endif
			C_CODE
		)
		r.process_source_file(s)
    assert_equal 1, r.count
	end

	def test_process_file_in_other_language
		r = KeywordRule.new('java', 'WIN32')
		s = Ohcount::SourceFile.new('header.c', :contents => <<-C_CODE
			// a comment
			#ifdef WIN32
      ..some code..
      #endif
			C_CODE
		)
		r.process_source_file(s)
    assert_equal 0, r.count
	end

	def test_process_file_with_any_language
		r = KeywordRule.new(nil, 'A', 'B')
		s = Ohcount::SourceFile.new('mixed.rhtml', :contents => <<-RHTML
			<% some ruby containing A -%>
			<div>B</div>
		RHTML
		)
		r.process_source_file(s)
		assert_equal 2, r.count
	end
end

