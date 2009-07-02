require 'test/unit'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

class FilenameRuleTest < Test::Unit::TestCase
  include Ohcount::Gestalt

	def test_process_file
		r = FilenameRule.new('foo\.rb')
		s = Ohcount::SourceFile.new('/bar/com/foo.rb', :contents => <<-RUBY_CODE
      # comment
      code = 1
			RUBY_CODE
		)
		assert r.process_source_file(s)
    assert_equal 1, r.count
	end
end


