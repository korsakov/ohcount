require File.dirname(__FILE__) + '/../../test_helper'

class FindJavaImportsRuleTest < Test::Unit::TestCase
  include Ohcount::Gestalt

  def test_truncate_name
		assert_equal "", FindJavaImportsRule.truncate_name(nil, 3)
		assert_equal "", FindJavaImportsRule.truncate_name("", 3)
		assert_equal "", FindJavaImportsRule.truncate_name("net.ohloh.ohcount.test", 0)
		assert_equal "net", FindJavaImportsRule.truncate_name("net.ohloh.ohcount.test", 1)
		assert_equal "net.ohloh", FindJavaImportsRule.truncate_name("net.ohloh.ohcount.test", 2)
		assert_equal "net.ohloh.ohcount", FindJavaImportsRule.truncate_name("net.ohloh.ohcount.test", 3)
		assert_equal "net.ohloh.ohcount.test", FindJavaImportsRule.truncate_name("net.ohloh.ohcount.test", 4)
		assert_equal "net.ohloh.ohcount.test", FindJavaImportsRule.truncate_name("net.ohloh.ohcount.test", 5)
	end

	def test_arm_from_java_import
    java = SourceFile.new("foo.java", :contents => <<-INLINE_C
			import org.opengroup.arm40.transaction.ArmConstants;
			// import dont.import.this;
      INLINE_C
    )

    expected_gestalts = [
      Base.new(:java_import, 'org.opengroup.arm40'),
      Base.new(:platform,    'Java'),
      Base.new(:platform,    'arm'),
    ]

    assert_equal expected_gestalts.sort, java.gestalts.sort
	end
end
