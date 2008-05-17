/*
 *  parser.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */


/*
 * ParseResult
 *
 * Calling parser_parse fills out one of these babies. Each language ('html', 'css'...) is
 * represented in its own language_breakdown.
 *
 */
typedef struct {
	LanguageBreakdown language_breakdowns[MAX_LANGUAGE_BREAKDOWN_SIZE];
	int language_breakdown_count;
} ParseResult;


/*
 * Fills out the ParseResult with the result of parsing the buffer with the specific Language
 */
void parse_result_free(ParseResult *parse_result);

/*
 * frees the memory held by the ParseResult
 */
void parser_parse(ParseResult *pr, char *buffer, int buffer_len, Polyglot *polyglot);

