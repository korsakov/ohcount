/*
 *  common.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */
#ifndef __common_h__
#define __common_h__

/*******************************************
 Limits
*******************************************/
// The Parser's CompiledState Stack
#define MAX_CS_STACK 20
// Parser's Maximum number of LanguageBreakdowns it can return
#define MAX_LANGUAGE_BREAKDOWN_SIZE 8
// How large can a CompiledState's regex term be?
#define MAX_REGEX 200
// CompiledState's number of transitions
#define MAX_TRANSITIONS 10
// The longest a language name can be
#define MAX_LANGUAGE_NAME 20

/*******************************************
 Common Headers
*******************************************/
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <pcre.h>
#include "transition.h"
#include "state.h"
#include "compiled_state.h"
#include "polyglot.h"
#include "polyglots.h"
#include "language_breakdown.h"
#include "parser.h"

/*******************************************
 Error Handling
*******************************************/
void die(char *err, int exit_code);

enum EXIT_CODES {
	ERR_PCRE_OUT_OF_MEMORY = 15,
	ERR_PCRE_GENERIC,
	ERR_UNKNOWN_SEMANTIC
};


/*******************************************
 Logging
*******************************************/

#ifdef NDEBUG
#define log(e, arg) ((void)0)
#define log0(e) ((void)0)
#define log2(e, arg1, arg2) ((void)0)
#else
#define log(e, arg) (fprintf(stderr, e, arg))
#define log0(e) (fprintf(stderr, e))
#define log2(e, arg1, arg2) (fprintf(stderr, e, arg1, arg2))
#endif


#endif /* common_h */
