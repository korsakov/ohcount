%%{
machine common;

# common definitions

# whitespace, non-printables
ws = [\t ];
spaces = [\t ]+;
newline = ('\r\n' | '\n' | '\f' | '\r' when { p+1 < pe && *(p+1) != '\n' });
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

# common entities
sq_str = '\'' [^']* '\'';
dq_str = '"' [^"]* '"';
sq_str_with_escapes = '\'' ([^'\\] | '\\' any)* '\'';
dq_str_with_escapes = '"' ([^"\\] | '\\' any)* '"';

# common actions

action enqueue {
  inqueue = 1;
  if (callback_list_head) free_queue(); // free the current queue
  callback_list_head = NULL;
  callback_list_tail = NULL;
  // set backup variables
  last_line_start = line_start;
  last_line_contains_code = line_contains_code;
  last_whole_line_comment = whole_line_comment;
}

action commit {
  if (inqueue) {
    Callback *item;
    for (item = callback_list_head; item != NULL; item = item->next)
      callback(item->lang, item->entity, item->s, item->e, item->udata);
    free_queue();
    inqueue = 0;
  }
}

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

action check_blank_outry {
  if (!line_contains_code && !whole_line_comment) seen = 0;
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
