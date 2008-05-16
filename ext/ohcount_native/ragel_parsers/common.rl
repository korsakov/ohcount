%%{
machine common;

# common definitions

# whitespace, non-printables
spaces = [\t ]+;
newline = ('\r\n' | '\n\r' | '\n' | '\f');
newlines = newline+;
escaped_newline = '\\' newline;
nonnewline = any - [\r\n\f];
nonprintable_char = cntrl - [\r\n\f];

# comments
c_style_line_comment = '//' nonnewline*;
c_style_line_comment_with_esc = '//' (escaped_newline | nonnewline)*;
c_style_block_comment = '/*' any* :>> '*/'?;
shell_style_line_comment = '#' nonnewline*;
shell_style_line_comment_with_esc = '#' (escaped_newline | nonnewline)*;

# numbers
dec_num = digit+;
hex_num = 0 [xX] [a-fA-F0-9]+;
oct_num = 0 [0-7]+;
integer = [+\-]? (hex_num | oct_num | dec_num);
float = [+\-]? ((digit* '.' digit+) | (digit+ '.' digit*) | digit+)
        [eE] [+\-]? digit+;

# strings
sq_str_with_esc = '\'' ([^'\\] | '\\' any)* '\''?;
dq_str_with_esc = '"' ([^"\\] | '\\' any)* '"'?;
bt_str_with_esc = '`' ([^`\\] | '\\' any)* '`'?;
re_str_with_esc = '/' ([^/\\] | '\\' any)* '/'?;

# common actions

# common conditionals

action starts_line {
  p == buffer || *(p-1) == '\r' || *(p-1) == '\n' || *(p-1) == '\f'
}
action starts_line2 {
  p == buffer || *(p-2) == '\r' || *(p-2) == '\n' || *(p-2) == '\f'
}
}%%
