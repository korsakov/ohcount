class foo
' comment

require File.dirname(__FILE__) + '/../test_helper'
include Lingo

class ShellTest < LingoTest
	def test_comment
		p = Languages::Shell.parse(" #comment")
		assert_equal({ 'shell' => { :comment => [" #comment"] } }, p.output_buffers)
	end

	def test_comprehensive
		verify_parse("sh1.sh")
	end
end
