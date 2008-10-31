require File.dirname(__FILE__) + '/../../test_helper'

class Ohcount::PerlTest < Ohcount::Test
	def test_comments
		lb = [Ohcount::LanguageBreakdown.new("perl", "", "#comment", 0)]
		assert_equal lb, Ohcount::parse(" #comment", "perl")
	end

	def test_perl_in_cgi
		verify_parse("perl.cgi")
	end

	def test_comprehensive
		verify_parse("perl1.pl")
		verify_parse("perl_module.pm")
		verify_parse("perl_pod_to_eof.pl") # Verifies ticket #267
	end

	def test_comment_entities
		assert_equal('#comment', entities_array(" #comment", 'perl', :comment).first)
		assert_equal("=head1\ncomment\n=cut", entities_array("=head1\ncomment\n=cut", 'perl', :comment).first)
	end
end
