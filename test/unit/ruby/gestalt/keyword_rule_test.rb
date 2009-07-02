require 'test/unit'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

class KeywordRuleTest < Test::Unit::TestCase
  include Ohcount::Gestalt

	def test_process_file
		r = KeywordRule.new('c', 'WIN32')
		s = Ohcount::SourceFile.new('header.c', :contents => <<-C_CODE
			// a comment
			#ifdef WIN32
      ..some code..
      #endif
			C_CODE
		)
		assert r.process_source_file(s)
    assert_equal 1, r.count
	end
end

