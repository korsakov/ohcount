/* comment block */
// single-line comment
int main(char[][] args)
{
	int w_total; // a comment and code on the same line

	/+ begin a nestable comment block
		/* this comment is nested within another */
		this_code_is_commented_out();
	+/

	/* when inside a c-style block comment, /+ does not start a nested comment */
  this_line_is_code();

	// when inside a line comment, /+ does not start a nested comment
	this_line_is_also_code();

	/+ when inside a nestable comment, /+ does begin a nested comment
	  now we close the inner comment +/
		This line is still part of the outer comment
	  now we close the outer comment +/

	x = `when inside a backtick string, /+ does not begin a nested comment`;
	y = `when inside a backtick string, /* does not begin a nested comment`;
	z = `when inside a backtick string, // does not begin a nested comment`;
}
