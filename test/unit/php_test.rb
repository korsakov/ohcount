require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::PhpTest < Ohcount::Test
	def test_comment
		lb = [Ohcount::LanguageBreakdown.new("php", "<?php\n?>", "//comment\n", 0)]
		assert_equal lb, Ohcount::parse("<?php\n //comment\n?>", "php")
	end

	def test_comprehensive
		verify_parse("php1.php")
	end
end
