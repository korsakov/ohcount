require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::PhpTest < Ohcount::Test
	def test_comment
		lbhtml = Ohcount::LanguageBreakdown.new("html", "<?php\n?>", "", 0)
    lbphp = Ohcount::LanguageBreakdown.new("php", "", "//comment\n", 0)
		assert_equal [lbhtml, lbphp], Ohcount::parse("<?php\n //comment\n?>", "php")
	end

	def test_comprehensive
		verify_parse("php1.php")
	end

	def test_comment_entities
		assert_equal('// comment', entities_array("<?php\n// comment\n?>\n", 'php', :comment).first)
		assert_equal('/* comment */', entities_array("<?php\n/* comment */\n?>\n", 'php', :comment).first)
	end
end
