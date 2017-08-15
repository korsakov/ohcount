sql	comment	// -----------------------------------------------------------------------
sql	comment	// Filename:   minvalue.sql
sql	comment	// Purpose:    Select the Nth lowest value from a table
sql	comment	// Date:       18-Apr-2001
sql	comment	// Author:     Deepak Rai, SSE, Satyam Computer Services Ltd. India
sql	comment	// -----------------------------------------------------------------------
sql	blank	
sql	comment	## Comment with a hash symbol ##
sql	code	select level, min('col_name') from my_table
sql	code	where level = '&n'
sql	code	connect by prior ('col_name') < 'col_name')
sql	code	group by level;
sql	blank	
sql	comment	/* a block comment
sql	comment	   -- finished here */
sql	blank	
sql	comment	-- Example:
sql	comment	--
sql	comment	-- Given a table called emp with the following columns:
sql	comment	--   id   number
sql	comment	--   name varchar2(20)
sql	comment	--   sal  number
sql	comment	--
sql	comment	-- For the second lowest salary:
sql	comment	--
sql	comment	-- select level, min(sal) from emp
sql	comment	-- where level=2
sql	comment	-- connect by prior sal < sal
sql	comment	-- group by level
sql	comment	--
sql	blank	
