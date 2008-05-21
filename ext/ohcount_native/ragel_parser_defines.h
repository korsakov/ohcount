
#define std_internal_newline(lang) { \
  if (callback && p > line_start) { \
    if (line_contains_code) \
      callback(lang, "lcode", cint(line_start), cint(p)); \
    else if (whole_line_comment) \
      callback(lang, "lcomment", cint(line_start), cint(p)); \
    else \
      callback(lang, "lblank", cint(line_start), cint(p)); \
  } \
  whole_line_comment = 0; \
  line_contains_code = 0; \
  line_start = p; \
}

#define std_newline(lang) {\
  if (callback && te > line_start) { \
    if (line_contains_code) \
      callback(lang, "lcode", cint(line_start), cint(te)); \
    else if (whole_line_comment) \
      callback(lang, "lcomment", cint(line_start), cint(te)); \
    else \
      callback(lang, "lblank", cint(ts), cint(te)); \
  } \
  whole_line_comment = 0; \
  line_contains_code = 0; \
  line_start = 0; \
}

#define code {\
  if (!line_contains_code && !line_start) line_start = ts; \
  line_contains_code = 1; \
}

#define ls { if (!line_start) line_start = ts; }
