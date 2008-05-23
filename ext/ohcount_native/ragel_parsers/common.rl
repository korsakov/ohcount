%%{
machine common;

# common definitions

# whitespace, non-printables
ws = [\t ];
spaces = [\t ]+;
newline = ('\r\n' | '\r' | '\n' | '\f');
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

action ls { if (!line_start) line_start = ts; }

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

action no_code { !line_contains_code }
action no_comment { !whole_line_comment }
action no_code_or_comment { !line_contains_code && !whole_line_comment }

action starts_line {
  p == buffer || *(p-1) == '\r' || *(p-1) == '\n' || *(p-1) == '\f'
}
action starts_line2 {
  p == buffer || *(p-2) == '\r' || *(p-2) == '\n' || *(p-2) == '\f'
}
}%%
