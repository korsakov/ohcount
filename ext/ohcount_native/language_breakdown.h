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
} LanguageBreakdown;

void language_breakdown_initialize(LanguageBreakdown *lb, char *name, int buffer_size);
void language_breakdown_copy_code(LanguageBreakdown *lb, char *from, char *to);
void language_breakdown_copy_comment(LanguageBreakdown *lb, char *from, char *to);

void language_breakdown_free(LanguageBreakdown *lb);
