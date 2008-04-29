// -----------------------------------------------------------------------
// Filename:   minvalue.sql
// Purpose:    Select the Nth lowest value from a table
// Date:       18-Apr-2001
// Author:     Deepak Rai, SSE, Satyam Computer Services Ltd. India
// -----------------------------------------------------------------------

## Comment with a hash symbol ##
select level, min('col_name') from my_table
where level = '&n'
connect by prior ('col_name') < 'col_name')
group by level;

/* a block comment
   -- finished here */

-- Example:
--
-- Given a table called emp with the following columns:
--   id   number
--   name varchar2(20)
--   sal  number
--
-- For the second lowest salary:
--
-- select level, min(sal) from emp
-- where level=2
-- connect by prior sal < sal
-- group by level
--

