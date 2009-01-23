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

	def test_language_breakdowns
		contents = "x = 5"
		f = SourceFile.new("foo.rb", :contents => contents)
		assert_equal 'ruby', f.language_breakdowns[0].name
		assert_equal contents, f.language_breakdowns('ruby').code
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

	def test_realize_file
		s = SourceFile.new('foo.c', :contents => 'i')
		s.realize_file do |f|
			assert_equal 'i', File.new(f).read
		end
	end

  def test_calc_diff
    old = SourceFile.new("foo.c", :contents => 'int i;')
    new = SourceFile.new("foo.c", :contents => 'int j;')

    c_si = Ohcount::SlocInfo.new('c', :code_added => 1, :code_removed => 1)
    assert_equal [c_si], old.diff(new)
  end

  def test_calc_diff_2
    old = SourceFile.new("foo.html", :contents => <<-INLINE_HTML
      <html>
        <script type='text/javascript'>
          var i = 1;
        </script>
        <style type="text/css">
          new_css_code
          /* css_comment */
        </style>
     </html>
    INLINE_HTML
    )
    new = SourceFile.new("foo.html", :contents => <<-INLINE_HTML
      <html>
        <script type='text/javascript'>
          var i = 2;
        </script>
        <style type="text/css">
          new_css_code
          /* different css_comment */
        </style>
     </html>
    INLINE_HTML
    )

    javascript_si = Ohcount::SlocInfo.new('javascript', :code_added => 1, :code_removed => 1)
    css_si = Ohcount::SlocInfo.new('css', :comments_added => 1, :comments_removed => 1)
    assert_equal [javascript_si, css_si], old.diff(new)
  end

  def test_calc_diff_longer
    old = SourceFile.new("foo.c", :contents => <<-INLINE_C
      int = 1;
      int = 2;
      int = 3;
      int = 4;
      INLINE_C
    )
    new = SourceFile.new("foo.c", :contents => <<-INLINE_C
      int = 1;
      int = 5;
      int = 6;
      int = 4;
      INLINE_C
    )
    c_si = Ohcount::SlocInfo.new('c', :code_added => 2, :code_removed => 2)
    assert_equal [c_si],old.diff(new)
  end
end

