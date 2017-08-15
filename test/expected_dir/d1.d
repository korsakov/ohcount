dmd	comment	/* comment block */
dmd	comment	// single-line comment
dmd	code	int main(char[][] args)
dmd	code	{
dmd	code		int w_total; // a comment and code on the same line
dmd	blank	
dmd	comment		/+ begin a nestable comment block
dmd	comment			/* this comment is nested within another */
dmd	comment			this_code_is_commented_out();
dmd	comment		+/
dmd	blank	
dmd	comment		/* when inside a c-style block comment, /+ does not start a nested comment */
dmd	code	  this_line_is_code();
dmd	blank	
dmd	comment		// when inside a line comment, /+ does not start a nested comment
dmd	code		this_line_is_also_code();
dmd	blank	
dmd	comment		/+ when inside a nestable comment, /+ does begin a nested comment
dmd	comment		  now we close the inner comment +/
dmd	comment			This line is still part of the outer comment
dmd	comment		  now we close the outer comment +/
dmd	blank	
dmd	code		x = `when inside a backtick string, /+ does not begin a nested comment`;
dmd	code		y = `when inside a backtick string, /* does not begin a nested comment`;
dmd	code		z = `when inside a backtick string, // does not begin a nested comment`;
dmd	code	}
