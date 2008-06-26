// ragel_parser.h written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/**
 * Each language (html, css, etc.) is represented in its own language_breakdown.
 */
typedef struct {
	LanguageBreakdown language_breakdowns[MAX_LANGUAGE_BREAKDOWN_SIZE];
	int language_breakdown_count;
} ParseResult;


/**
 * Fills out the ParseResult with the result of parsing the buffer with the specific Language.
 */
int ragel_parser_parse(ParseResult *pr, int count, char *buf, int buf_len, char *lang);
