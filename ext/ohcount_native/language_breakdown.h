/*
 *  language_breakdown.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/26/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

typedef struct {
	char name[MAX_LANGUAGE_NAME];
	char *code;
	char *code_cur;
	char *comment;
	char *comment_cur;
	int blank_count;
	int code_count;
	int comment_count;
	int buffer_size;
} LanguageBreakdown;

void language_breakdown_initialize(LanguageBreakdown *lb, char *name, int buffer_size);
int language_breakdown_append_code_line(LanguageBreakdown *lb, char *from, char *to);
int language_breakdown_append_comment_line(LanguageBreakdown *lb, char *from, char *to);

void language_breakdown_free(LanguageBreakdown *lb);
