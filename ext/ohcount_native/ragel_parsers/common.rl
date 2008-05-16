%%{
machine common;

# common definitions

# whitespace, non-printables
spaces = [\t ]+;
newline = ('\r\n' | '\n\r' | '\n' | '\f');
escaped_newline = '\\' newline;
nonnewline = any - [\r\n\f];
nonprintable_char = cntrl - [\r\n\f];

# numbers
dec_num = digit+;
hex_num = 0 [xX] [a-fA-F0-9]+;
oct_num = 0 [0-7]+;
integer = [+\-]? (hex_num | oct_num | dec_num);
float = [+\-]? ((digit* '.' digit+) | (digit+ '.' digit*) | digit+)
        [eE] [+\-]? digit+;

# common actions

action code {
  if (!line_contains_code && !line_start) line_start = ts;
  line_contains_code = 1;
}

action comment {
  if (!line_contains_code) {
    whole_line_comment = 1;
    if (!line_start) line_start = ts;
  }
}

# common conditionals

action starts_line {
  p == buffer || *(p-1) == '\r' || *(p-1) == '\n' || *(p-1) == '\f'
}
action starts_line2 {
  p == buffer || *(p-2) == '\r' || *(p-2) == '\n' || *(p-2) == '\f'
}
}%%
