require File.dirname(__FILE__) + '/../../test_helper'

class CSharpUsingRuleTest < Test::Unit::TestCase
  include Ohcount::Gestalt


  def test_sample
		cs = SourceFile.new("hello.cs", :contents => <<-INLINE
using System;
using System.Foo;
using NUnit.Framework;

namespace Hello
{
	/// Hi there
}
		INLINE
		)

		r = CSharpUsingRule.new(/System/)
		r.process_source_file(cs)
		assert_equal 2, r.count

		r = CSharpUsingRule.new(/^System$/)
		r.process_source_file(cs)
		assert_equal 1, r.count

		r = CSharpUsingRule.new(/.+/)
		r.process_source_file(cs)
		assert_equal 3, r.count

  end
end
