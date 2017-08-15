visualbasic	blank	
visualbasic	code	require File.dirname(__FILE__) + '/../test_helper'
visualbasic	code	include Lingo
visualbasic	blank	
visualbasic	code	class ShellTest < LingoTest
visualbasic	code		def test_comment
visualbasic	code			p = Languages::Shell.parse(" #comment")
visualbasic	code			assert_equal({ 'shell' => { :comment => [" #comment"] } }, p.output_buffers)
visualbasic	code		end
visualbasic	blank	
visualbasic	code		def test_comprehensive
visualbasic	code			verify_parse("sh1.sh")
visualbasic	code		end
visualbasic	code	end
