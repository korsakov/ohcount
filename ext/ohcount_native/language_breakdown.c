/*
 *  language_breakdown.c
 *  Ohcount
 *
 *  Created by Jason Allen on 6/26/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

#include "common.h"

/*
 * language_breakdown_initialize
 *
 * sets up the blank buffers...
 *
 */
void language_breakdown_initialize(LanguageBreakdown *lb, char *name, int buffer_size) {
	strcpy(lb->name, name);
	lb->code    = lb->code_cur    = malloc(buffer_size);
	lb->code[0] = 0;
	lb->comment = lb->comment_cur = malloc(buffer_size);
	lb->comment[0] = 0;
	lb->blank_count = 0;
	lb->buffer_size = buffer_size;
}

/*
 * language_breakdown_free
 *
 * frees the buffers allocated by a language_breakdown
 *
 */
void language_breakdown_free(LanguageBreakdown *lb) {
#ifndef NDEBUG
	if (lb->code == NULL || lb->comment == NULL) {
		log0("freeing language_breakdown twice!");
	}
#endif
	free(lb->code);
	free(lb->comment);
	lb->code = NULL;
	lb->comment = NULL;
}


char * first_non_blank(char *from, char *to) {
	while (from < to && (*from == ' ' || *from == '\t')) {
		from++;
	}
	return from;
}

/*
 * language_breakdown_copy_code
 *
 * copies the passed in string (via delimiters) to the code buffer
 *
 * Returns 1 on success, 0 on buffer overflow. Buffer overflows typically occur
 * for language syntax errors (e.g. unclosed strings or block comments) or
 * parser errors.
 */
int language_breakdown_copy_code(LanguageBreakdown *lb, char *from, char *to) {
	from = first_non_blank(from, to);
	if (lb->code_cur + (to - from) >= lb->code + lb->buffer_size)
		return 0; // overflow error
	strncpy(lb->code_cur, from, to - from);
	lb->code_cur += to - from;
	*lb->code_cur = 0;
	return 1;
}

/*
 * language_breakdown_copy_comment
 *
 * copies the passed in string (via delimiters) to the comment buffer
 *
 * Returns 1 on success, 0 on buffer overflow. Buffer overflows typically occur
 * for language syntax errors (e.g. unclosed strings or block comments) or
 * parser errors.
 */
int language_breakdown_copy_comment(LanguageBreakdown *lb, char *from, char *to) {
	from = first_non_blank(from, to);
	if (lb->comment_cur + (to - from) >= lb->comment + lb->buffer_size)
		return 0; // overflow error
	strncpy(lb->comment_cur, from, to - from);
	lb->comment_cur += to - from;
	*lb->comment_cur = 0;
	return 1;
}
