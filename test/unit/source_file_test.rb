require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class SourceFileTest < Ohcount::Test

	def test_initialize
		assert SourceFile.new("foo.rb")
	end

	def test_contents
		contents = "foobar"
		f = SourceFile.new("foo.rb", :contents => contents)
		assert_equal contents, f.contents
	end

	def test_languages
		contents = "x = 5"
		f = SourceFile.new("foo.rb", :contents => contents)
		assert_equal [:ruby], f.languages
		assert_equal({:code => contents}, f.ruby)
		assert_equal contents, f.ruby.code
	end

	def test_parse
		ruby_code = ''
		contents = "x = 5"
		f = SourceFile.new("foo.rb", :contents => contents)
		f.parse do |l, s, line|
			ruby_code << line if l == :ruby && s == :code
		end
		assert_equal contents, ruby_code
	end
end

