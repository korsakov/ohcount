/*
 * polyglots.c
 * Ohcount
 *
 * GENERATED FILE **DO NOT EDIT**
 *
 */

#define __polyglots_c__
#include "common.h"

#define RETURN (State *)NULL

/*****************************************************************************
                                      ada
*****************************************************************************/
/* States */
State ADA_CODE = { "ADA_CODE", "ada", semantic_code };
State ADA_DQUOTE_STRING = { "ADA_DQUOTE_STRING", "ada", semantic_code };
State ADA_SQUOTE_STRING = { "ADA_SQUOTE_STRING", "ada", semantic_code };
State ADA_LINE_COMMENT = { "ADA_LINE_COMMENT", "ada", semantic_comment };
State ADA_BLOCK_COMMENT = { "ADA_BLOCK_COMMENT", "ada", semantic_comment };
State *ADA_STATES[] = { &ADA_CODE, &ADA_DQUOTE_STRING, &ADA_SQUOTE_STRING, &ADA_LINE_COMMENT, &ADA_BLOCK_COMMENT, NULL };
/* Transitions */
Transition ADA_CODE__LINE_COMMENT_0 = { "--", &ADA_CODE, &ADA_LINE_COMMENT, ToEatsToken, false };
Transition ADA_LINE_COMMENT__RETURN = { "\n", &ADA_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition ADA_CODE__DQUOTE_STRING = { "\"", &ADA_CODE, &ADA_DQUOTE_STRING, ToEatsToken, false };
Transition ADA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &ADA_DQUOTE_STRING, &ADA_DQUOTE_STRING, ToEatsToken, true };
Transition ADA_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &ADA_DQUOTE_STRING, &ADA_DQUOTE_STRING, ToEatsToken, true };
Transition ADA_DQUOTE_STRING__RETURN = { "\"", &ADA_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *ADA_TRANSITIONS[] = { &ADA_CODE__LINE_COMMENT_0, &ADA_LINE_COMMENT__RETURN, &ADA_CODE__DQUOTE_STRING, &ADA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &ADA_DQUOTE_STRING__DQUOTE_STRING_ESC, &ADA_DQUOTE_STRING__RETURN, NULL};
Polyglot ADA_POLYGLOT = {
	"ada",
			ADA_STATES,
			ADA_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                   assembler
*****************************************************************************/
/* States */
State ASSEMBLER_CODE = { "ASSEMBLER_CODE", "assembler", semantic_code };
State ASSEMBLER_DQUOTE_STRING = { "ASSEMBLER_DQUOTE_STRING", "assembler", semantic_code };
State ASSEMBLER_SQUOTE_STRING = { "ASSEMBLER_SQUOTE_STRING", "assembler", semantic_code };
State ASSEMBLER_LINE_COMMENT = { "ASSEMBLER_LINE_COMMENT", "assembler", semantic_comment };
State ASSEMBLER_BLOCK_COMMENT = { "ASSEMBLER_BLOCK_COMMENT", "assembler", semantic_comment };
State *ASSEMBLER_STATES[] = { &ASSEMBLER_CODE, &ASSEMBLER_DQUOTE_STRING, &ASSEMBLER_SQUOTE_STRING, &ASSEMBLER_LINE_COMMENT, &ASSEMBLER_BLOCK_COMMENT, NULL };
/* Transitions */
Transition ASSEMBLER_CODE__LINE_COMMENT_0 = { ";", &ASSEMBLER_CODE, &ASSEMBLER_LINE_COMMENT, ToEatsToken, false };
Transition ASSEMBLER_CODE__LINE_COMMENT_1 = { "!", &ASSEMBLER_CODE, &ASSEMBLER_LINE_COMMENT, ToEatsToken, false };
Transition ASSEMBLER_CODE__LINE_COMMENT_2 = { "//", &ASSEMBLER_CODE, &ASSEMBLER_LINE_COMMENT, ToEatsToken, false };
Transition ASSEMBLER_LINE_COMMENT__RETURN = { "\n", &ASSEMBLER_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition ASSEMBLER_CODE__BLOCK_COMMENT_0 = { "/\\*", &ASSEMBLER_CODE, &ASSEMBLER_BLOCK_COMMENT, ToEatsToken, false };
Transition ASSEMBLER_BLOCK_COMMENT__RETURN_0 = { "\\*/", &ASSEMBLER_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition *ASSEMBLER_TRANSITIONS[] = { &ASSEMBLER_CODE__LINE_COMMENT_0, &ASSEMBLER_CODE__LINE_COMMENT_1, &ASSEMBLER_CODE__LINE_COMMENT_2, &ASSEMBLER_LINE_COMMENT__RETURN, &ASSEMBLER_CODE__BLOCK_COMMENT_0, &ASSEMBLER_BLOCK_COMMENT__RETURN_0, NULL};
Polyglot ASSEMBLER_POLYGLOT = {
	"assembler",
			ASSEMBLER_STATES,
			ASSEMBLER_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      awk
*****************************************************************************/
/* States */
State AWK_CODE = { "AWK_CODE", "awk", semantic_code };
State AWK_DQUOTE_STRING = { "AWK_DQUOTE_STRING", "awk", semantic_code };
State AWK_SQUOTE_STRING = { "AWK_SQUOTE_STRING", "awk", semantic_code };
State AWK_LINE_COMMENT = { "AWK_LINE_COMMENT", "awk", semantic_comment };
State AWK_BLOCK_COMMENT = { "AWK_BLOCK_COMMENT", "awk", semantic_comment };
State *AWK_STATES[] = { &AWK_CODE, &AWK_DQUOTE_STRING, &AWK_SQUOTE_STRING, &AWK_LINE_COMMENT, &AWK_BLOCK_COMMENT, NULL };
/* Transitions */
Transition AWK_CODE__LINE_COMMENT_0 = { "#", &AWK_CODE, &AWK_LINE_COMMENT, ToEatsToken, false };
Transition AWK_LINE_COMMENT__RETURN = { "\n", &AWK_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition AWK_CODE__DQUOTE_STRING = { "\"", &AWK_CODE, &AWK_DQUOTE_STRING, ToEatsToken, false };
Transition AWK_DQUOTE_STRING__RETURN = { "\"", &AWK_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *AWK_TRANSITIONS[] = { &AWK_CODE__LINE_COMMENT_0, &AWK_LINE_COMMENT__RETURN, &AWK_CODE__DQUOTE_STRING, &AWK_DQUOTE_STRING__RETURN, NULL};
Polyglot AWK_POLYGLOT = {
	"awk",
			AWK_STATES,
			AWK_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      bat
*****************************************************************************/
/* States */
State BAT_CODE = { "BAT_CODE", "bat", semantic_code };
State BAT_COMMENT = { "BAT_COMMENT", "bat", semantic_comment };
State *BAT_STATES[] = { &BAT_CODE, &BAT_COMMENT, NULL };
/* Transitions */
Transition BAT_CODE__COMMENT_0 = { "^\\s*(?i)REM(?-i)", &BAT_CODE, &BAT_COMMENT, ToEatsToken, false };
Transition BAT_COMMENT__RETURN = { "\n", &BAT_COMMENT, RETURN, FromEatsToken, false };
Transition *BAT_TRANSITIONS[] = { &BAT_CODE__COMMENT_0, &BAT_COMMENT__RETURN, NULL};
Polyglot BAT_POLYGLOT = {
	"bat",
			BAT_STATES,
			BAT_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      boo
*****************************************************************************/
/* States */
State BOO_CODE = { "BOO_CODE", "boo", semantic_code };
State BOO_MULTI_LINE_SQUOTE = { "BOO_MULTI_LINE_SQUOTE", "boo", semantic_code };
State BOO_MULTI_LINE_DQUOTE = { "BOO_MULTI_LINE_DQUOTE", "boo", semantic_code };
State BOO_RAW_DQUOTE = { "BOO_RAW_DQUOTE", "boo", semantic_code };
State BOO_SQUOTE = { "BOO_SQUOTE", "boo", semantic_code };
State BOO_DQUOTE = { "BOO_DQUOTE", "boo", semantic_code };
State BOO_LINE_COMMENT = { "BOO_LINE_COMMENT", "boo", semantic_comment };
State *BOO_STATES[] = { &BOO_CODE, &BOO_MULTI_LINE_SQUOTE, &BOO_MULTI_LINE_DQUOTE, &BOO_RAW_DQUOTE, &BOO_SQUOTE, &BOO_DQUOTE, &BOO_LINE_COMMENT, NULL };
/* Transitions */
Transition BOO_CODE__MULTI_LINE_SQUOTE = { "'''", &BOO_CODE, &BOO_MULTI_LINE_SQUOTE, FromEatsToken, false };
Transition BOO_MULTI_LINE_SQUOTE__RETURN = { "'''", &BOO_MULTI_LINE_SQUOTE, RETURN, FromEatsToken, false };
Transition BOO_CODE__MULTI_LINE_DQUOTE = { "\"\"\"", &BOO_CODE, &BOO_MULTI_LINE_DQUOTE, FromEatsToken, false };
Transition BOO_MULTI_LINE_DQUOTE__RETURN = { "\"\"\"", &BOO_MULTI_LINE_DQUOTE, RETURN, FromEatsToken, false };
Transition BOO_CODE__RAW_DQUOTE = { "r\"", &BOO_CODE, &BOO_RAW_DQUOTE, FromEatsToken, false };
Transition BOO_RAW_DQUOTE__RETURN = { "\"", &BOO_RAW_DQUOTE, RETURN, FromEatsToken, false };
Transition BOO_CODE__SQUOTE = { "'", &BOO_CODE, &BOO_SQUOTE, FromEatsToken, false };
Transition BOO_SQUOTE__RETURN_ESC = { "\\\\'", &BOO_SQUOTE, RETURN, FromEatsToken, true };
Transition BOO_SQUOTE__RETURN = { "'", &BOO_SQUOTE, RETURN, ToEatsToken, false };
Transition BOO_CODE__DQUOTE = { "\"", &BOO_CODE, &BOO_DQUOTE, ToEatsToken, false };
Transition BOO_DQUOTE__RETURN_ESC = { "\\\\\"", &BOO_DQUOTE, RETURN, FromEatsToken, true };
Transition BOO_DQUOTE__RETURN = { "\"", &BOO_DQUOTE, RETURN, ToEatsToken, false };
Transition BOO_CODE__LINE_COMMENT = { "#", &BOO_CODE, &BOO_LINE_COMMENT, ToEatsToken, false };
Transition BOO_LINE_COMMENT__RETURN = { "\n", &BOO_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition *BOO_TRANSITIONS[] = { &BOO_CODE__MULTI_LINE_SQUOTE, &BOO_MULTI_LINE_SQUOTE__RETURN, &BOO_CODE__MULTI_LINE_DQUOTE, &BOO_MULTI_LINE_DQUOTE__RETURN, &BOO_CODE__RAW_DQUOTE, &BOO_RAW_DQUOTE__RETURN, &BOO_CODE__SQUOTE, &BOO_SQUOTE__RETURN_ESC, &BOO_SQUOTE__RETURN, &BOO_CODE__DQUOTE, &BOO_DQUOTE__RETURN_ESC, &BOO_DQUOTE__RETURN, &BOO_CODE__LINE_COMMENT, &BOO_LINE_COMMENT__RETURN, NULL};
Polyglot BOO_POLYGLOT = {
	"boo",
			BOO_STATES,
			BOO_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                  clearsilver
*****************************************************************************/
/* States */
State CLEARSILVER_CODE = { "CLEARSILVER_CODE", "clearsilver", semantic_code };
State CLEARSILVER_DQUOTE_STRING = { "CLEARSILVER_DQUOTE_STRING", "clearsilver", semantic_code };
State CLEARSILVER_SQUOTE_STRING = { "CLEARSILVER_SQUOTE_STRING", "clearsilver", semantic_code };
State CLEARSILVER_LINE_COMMENT = { "CLEARSILVER_LINE_COMMENT", "clearsilver", semantic_comment };
State CLEARSILVER_BLOCK_COMMENT = { "CLEARSILVER_BLOCK_COMMENT", "clearsilver", semantic_comment };
State *CLEARSILVER_STATES[] = { &CLEARSILVER_CODE, &CLEARSILVER_DQUOTE_STRING, &CLEARSILVER_SQUOTE_STRING, &CLEARSILVER_LINE_COMMENT, &CLEARSILVER_BLOCK_COMMENT, NULL };
/* Transitions */
Transition CLEARSILVER_CODE__LINE_COMMENT_0 = { "#", &CLEARSILVER_CODE, &CLEARSILVER_LINE_COMMENT, ToEatsToken, false };
Transition CLEARSILVER_LINE_COMMENT__RETURN = { "\n", &CLEARSILVER_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition CLEARSILVER_CODE__SQUOTE_STRING = { "'", &CLEARSILVER_CODE, &CLEARSILVER_SQUOTE_STRING, ToEatsToken, false };
Transition CLEARSILVER_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &CLEARSILVER_SQUOTE_STRING, &CLEARSILVER_SQUOTE_STRING, FromEatsToken, true };
Transition CLEARSILVER_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &CLEARSILVER_SQUOTE_STRING, &CLEARSILVER_SQUOTE_STRING, FromEatsToken, true };
Transition CLEARSILVER_SQUOTE_STRING__RETURN = { "'", &CLEARSILVER_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition CLEARSILVER_CODE__DQUOTE_STRING = { "\"", &CLEARSILVER_CODE, &CLEARSILVER_DQUOTE_STRING, ToEatsToken, false };
Transition CLEARSILVER_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &CLEARSILVER_DQUOTE_STRING, &CLEARSILVER_DQUOTE_STRING, ToEatsToken, true };
Transition CLEARSILVER_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &CLEARSILVER_DQUOTE_STRING, &CLEARSILVER_DQUOTE_STRING, ToEatsToken, true };
Transition CLEARSILVER_DQUOTE_STRING__RETURN = { "\"", &CLEARSILVER_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *CLEARSILVER_TRANSITIONS[] = { &CLEARSILVER_CODE__LINE_COMMENT_0, &CLEARSILVER_LINE_COMMENT__RETURN, &CLEARSILVER_CODE__SQUOTE_STRING, &CLEARSILVER_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &CLEARSILVER_SQUOTE_STRING__SQUOTE_STRING_ESC, &CLEARSILVER_SQUOTE_STRING__RETURN, &CLEARSILVER_CODE__DQUOTE_STRING, &CLEARSILVER_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &CLEARSILVER_DQUOTE_STRING__DQUOTE_STRING_ESC, &CLEARSILVER_DQUOTE_STRING__RETURN, NULL};
Polyglot CLEARSILVER_POLYGLOT = {
	"clearsilver",
			CLEARSILVER_STATES,
			CLEARSILVER_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     cncpp
*****************************************************************************/
/* States */
State CNCPP_CODE = { "CNCPP_CODE", "cncpp", semantic_code };
State CNCPP_DQUOTE_STRING = { "CNCPP_DQUOTE_STRING", "cncpp", semantic_code };
State CNCPP_SQUOTE_STRING = { "CNCPP_SQUOTE_STRING", "cncpp", semantic_code };
State CNCPP_LINE_COMMENT = { "CNCPP_LINE_COMMENT", "cncpp", semantic_comment };
State CNCPP_BLOCK_COMMENT = { "CNCPP_BLOCK_COMMENT", "cncpp", semantic_comment };
State *CNCPP_STATES[] = { &CNCPP_CODE, &CNCPP_DQUOTE_STRING, &CNCPP_SQUOTE_STRING, &CNCPP_LINE_COMMENT, &CNCPP_BLOCK_COMMENT, NULL };
/* Transitions */
Transition CNCPP_CODE__LINE_COMMENT_0 = { "//", &CNCPP_CODE, &CNCPP_LINE_COMMENT, ToEatsToken, false };
Transition CNCPP_LINE_COMMENT__RETURN = { "\n", &CNCPP_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition CNCPP_CODE__BLOCK_COMMENT_0 = { "/\\*", &CNCPP_CODE, &CNCPP_BLOCK_COMMENT, ToEatsToken, false };
Transition CNCPP_BLOCK_COMMENT__RETURN_0 = { "\\*/", &CNCPP_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition CNCPP_CODE__DQUOTE_STRING = { "\"", &CNCPP_CODE, &CNCPP_DQUOTE_STRING, ToEatsToken, false };
Transition CNCPP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &CNCPP_DQUOTE_STRING, &CNCPP_DQUOTE_STRING, ToEatsToken, true };
Transition CNCPP_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &CNCPP_DQUOTE_STRING, &CNCPP_DQUOTE_STRING, ToEatsToken, true };
Transition CNCPP_DQUOTE_STRING__RETURN = { "\"", &CNCPP_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *CNCPP_TRANSITIONS[] = { &CNCPP_CODE__LINE_COMMENT_0, &CNCPP_LINE_COMMENT__RETURN, &CNCPP_CODE__BLOCK_COMMENT_0, &CNCPP_BLOCK_COMMENT__RETURN_0, &CNCPP_CODE__DQUOTE_STRING, &CNCPP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &CNCPP_DQUOTE_STRING__DQUOTE_STRING_ESC, &CNCPP_DQUOTE_STRING__RETURN, NULL};
Polyglot CNCPP_POLYGLOT = {
	"cncpp",
			CNCPP_STATES,
			CNCPP_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     csharp
*****************************************************************************/
/* States */
State CSHARP_CODE = { "CSHARP_CODE", "csharp", semantic_code };
State CSHARP_DQUOTE_STRING = { "CSHARP_DQUOTE_STRING", "csharp", semantic_code };
State CSHARP_SQUOTE_STRING = { "CSHARP_SQUOTE_STRING", "csharp", semantic_code };
State CSHARP_LINE_COMMENT = { "CSHARP_LINE_COMMENT", "csharp", semantic_comment };
State CSHARP_BLOCK_COMMENT = { "CSHARP_BLOCK_COMMENT", "csharp", semantic_comment };
State *CSHARP_STATES[] = { &CSHARP_CODE, &CSHARP_DQUOTE_STRING, &CSHARP_SQUOTE_STRING, &CSHARP_LINE_COMMENT, &CSHARP_BLOCK_COMMENT, NULL };
/* Transitions */
Transition CSHARP_CODE__LINE_COMMENT_0 = { "//", &CSHARP_CODE, &CSHARP_LINE_COMMENT, ToEatsToken, false };
Transition CSHARP_LINE_COMMENT__RETURN = { "\n", &CSHARP_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition CSHARP_CODE__BLOCK_COMMENT_0 = { "/\\*", &CSHARP_CODE, &CSHARP_BLOCK_COMMENT, ToEatsToken, false };
Transition CSHARP_BLOCK_COMMENT__RETURN_0 = { "\\*/", &CSHARP_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition CSHARP_CODE__DQUOTE_STRING = { "\"", &CSHARP_CODE, &CSHARP_DQUOTE_STRING, ToEatsToken, false };
Transition CSHARP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &CSHARP_DQUOTE_STRING, &CSHARP_DQUOTE_STRING, ToEatsToken, true };
Transition CSHARP_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &CSHARP_DQUOTE_STRING, &CSHARP_DQUOTE_STRING, ToEatsToken, true };
Transition CSHARP_DQUOTE_STRING__RETURN = { "\"", &CSHARP_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *CSHARP_TRANSITIONS[] = { &CSHARP_CODE__LINE_COMMENT_0, &CSHARP_LINE_COMMENT__RETURN, &CSHARP_CODE__BLOCK_COMMENT_0, &CSHARP_BLOCK_COMMENT__RETURN_0, &CSHARP_CODE__DQUOTE_STRING, &CSHARP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &CSHARP_DQUOTE_STRING__DQUOTE_STRING_ESC, &CSHARP_DQUOTE_STRING__RETURN, NULL};
Polyglot CSHARP_POLYGLOT = {
	"csharp",
			CSHARP_STATES,
			CSHARP_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      css
*****************************************************************************/
/* States */
State CSS_CODE = { "CSS_CODE", "css", semantic_code };
State CSS_DQUOTE_STRING = { "CSS_DQUOTE_STRING", "css", semantic_code };
State CSS_SQUOTE_STRING = { "CSS_SQUOTE_STRING", "css", semantic_code };
State CSS_LINE_COMMENT = { "CSS_LINE_COMMENT", "css", semantic_comment };
State CSS_BLOCK_COMMENT = { "CSS_BLOCK_COMMENT", "css", semantic_comment };
State *CSS_STATES[] = { &CSS_CODE, &CSS_DQUOTE_STRING, &CSS_SQUOTE_STRING, &CSS_LINE_COMMENT, &CSS_BLOCK_COMMENT, NULL };
/* Transitions */
Transition CSS_CODE__BLOCK_COMMENT_0 = { "/\\*", &CSS_CODE, &CSS_BLOCK_COMMENT, ToEatsToken, false };
Transition CSS_BLOCK_COMMENT__RETURN_0 = { "\\*/", &CSS_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition *CSS_TRANSITIONS[] = { &CSS_CODE__BLOCK_COMMENT_0, &CSS_BLOCK_COMMENT__RETURN_0, NULL};
Polyglot CSS_POLYGLOT = {
	"css",
			CSS_STATES,
			CSS_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     dylan
*****************************************************************************/
/* States */
State DYLAN_CODE = { "DYLAN_CODE", "dylan", semantic_code };
State DYLAN_DQUOTE_STRING = { "DYLAN_DQUOTE_STRING", "dylan", semantic_code };
State DYLAN_SQUOTE_STRING = { "DYLAN_SQUOTE_STRING", "dylan", semantic_code };
State DYLAN_LINE_COMMENT = { "DYLAN_LINE_COMMENT", "dylan", semantic_comment };
State DYLAN_BLOCK_COMMENT = { "DYLAN_BLOCK_COMMENT", "dylan", semantic_comment };
State *DYLAN_STATES[] = { &DYLAN_CODE, &DYLAN_DQUOTE_STRING, &DYLAN_SQUOTE_STRING, &DYLAN_LINE_COMMENT, &DYLAN_BLOCK_COMMENT, NULL };
/* Transitions */
Transition DYLAN_CODE__LINE_COMMENT_0 = { "//", &DYLAN_CODE, &DYLAN_LINE_COMMENT, ToEatsToken, false };
Transition DYLAN_LINE_COMMENT__RETURN = { "\n", &DYLAN_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition DYLAN_CODE__DQUOTE_STRING = { "\"", &DYLAN_CODE, &DYLAN_DQUOTE_STRING, ToEatsToken, false };
Transition DYLAN_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &DYLAN_DQUOTE_STRING, &DYLAN_DQUOTE_STRING, ToEatsToken, true };
Transition DYLAN_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &DYLAN_DQUOTE_STRING, &DYLAN_DQUOTE_STRING, ToEatsToken, true };
Transition DYLAN_DQUOTE_STRING__RETURN = { "\"", &DYLAN_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *DYLAN_TRANSITIONS[] = { &DYLAN_CODE__LINE_COMMENT_0, &DYLAN_LINE_COMMENT__RETURN, &DYLAN_CODE__DQUOTE_STRING, &DYLAN_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &DYLAN_DQUOTE_STRING__DQUOTE_STRING_ESC, &DYLAN_DQUOTE_STRING__RETURN, NULL};
Polyglot DYLAN_POLYGLOT = {
	"dylan",
			DYLAN_STATES,
			DYLAN_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     erlang
*****************************************************************************/
/* States */
State ERLANG_CODE = { "ERLANG_CODE", "erlang", semantic_code };
State ERLANG_DQUOTE_STRING = { "ERLANG_DQUOTE_STRING", "erlang", semantic_code };
State ERLANG_SQUOTE_STRING = { "ERLANG_SQUOTE_STRING", "erlang", semantic_code };
State ERLANG_LINE_COMMENT = { "ERLANG_LINE_COMMENT", "erlang", semantic_comment };
State ERLANG_BLOCK_COMMENT = { "ERLANG_BLOCK_COMMENT", "erlang", semantic_comment };
State *ERLANG_STATES[] = { &ERLANG_CODE, &ERLANG_DQUOTE_STRING, &ERLANG_SQUOTE_STRING, &ERLANG_LINE_COMMENT, &ERLANG_BLOCK_COMMENT, NULL };
/* Transitions */
Transition ERLANG_CODE__LINE_COMMENT_0 = { "%%", &ERLANG_CODE, &ERLANG_LINE_COMMENT, ToEatsToken, false };
Transition ERLANG_LINE_COMMENT__RETURN = { "\n", &ERLANG_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition ERLANG_CODE__SQUOTE_STRING = { "'", &ERLANG_CODE, &ERLANG_SQUOTE_STRING, ToEatsToken, false };
Transition ERLANG_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &ERLANG_SQUOTE_STRING, &ERLANG_SQUOTE_STRING, FromEatsToken, true };
Transition ERLANG_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &ERLANG_SQUOTE_STRING, &ERLANG_SQUOTE_STRING, FromEatsToken, true };
Transition ERLANG_SQUOTE_STRING__RETURN = { "'", &ERLANG_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition ERLANG_CODE__DQUOTE_STRING = { "\"", &ERLANG_CODE, &ERLANG_DQUOTE_STRING, ToEatsToken, false };
Transition ERLANG_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &ERLANG_DQUOTE_STRING, &ERLANG_DQUOTE_STRING, ToEatsToken, true };
Transition ERLANG_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &ERLANG_DQUOTE_STRING, &ERLANG_DQUOTE_STRING, ToEatsToken, true };
Transition ERLANG_DQUOTE_STRING__RETURN = { "\"", &ERLANG_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *ERLANG_TRANSITIONS[] = { &ERLANG_CODE__LINE_COMMENT_0, &ERLANG_LINE_COMMENT__RETURN, &ERLANG_CODE__SQUOTE_STRING, &ERLANG_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &ERLANG_SQUOTE_STRING__SQUOTE_STRING_ESC, &ERLANG_SQUOTE_STRING__RETURN, &ERLANG_CODE__DQUOTE_STRING, &ERLANG_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &ERLANG_DQUOTE_STRING__DQUOTE_STRING_ESC, &ERLANG_DQUOTE_STRING__RETURN, NULL};
Polyglot ERLANG_POLYGLOT = {
	"erlang",
			ERLANG_STATES,
			ERLANG_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     groovy
*****************************************************************************/
/* States */
State GROOVY_CODE = { "GROOVY_CODE", "groovy", semantic_code };
State GROOVY_DQUOTE_STRING = { "GROOVY_DQUOTE_STRING", "groovy", semantic_code };
State GROOVY_SQUOTE_STRING = { "GROOVY_SQUOTE_STRING", "groovy", semantic_code };
State GROOVY_LINE_COMMENT = { "GROOVY_LINE_COMMENT", "groovy", semantic_comment };
State GROOVY_BLOCK_COMMENT = { "GROOVY_BLOCK_COMMENT", "groovy", semantic_comment };
State *GROOVY_STATES[] = { &GROOVY_CODE, &GROOVY_DQUOTE_STRING, &GROOVY_SQUOTE_STRING, &GROOVY_LINE_COMMENT, &GROOVY_BLOCK_COMMENT, NULL };
/* Transitions */
Transition GROOVY_CODE__LINE_COMMENT_0 = { "//", &GROOVY_CODE, &GROOVY_LINE_COMMENT, ToEatsToken, false };
Transition GROOVY_LINE_COMMENT__RETURN = { "\n", &GROOVY_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition GROOVY_CODE__BLOCK_COMMENT_0 = { "/\\*", &GROOVY_CODE, &GROOVY_BLOCK_COMMENT, ToEatsToken, false };
Transition GROOVY_BLOCK_COMMENT__RETURN_0 = { "\\*/", &GROOVY_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition GROOVY_CODE__DQUOTE_STRING = { "\"", &GROOVY_CODE, &GROOVY_DQUOTE_STRING, ToEatsToken, false };
Transition GROOVY_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &GROOVY_DQUOTE_STRING, &GROOVY_DQUOTE_STRING, ToEatsToken, true };
Transition GROOVY_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &GROOVY_DQUOTE_STRING, &GROOVY_DQUOTE_STRING, ToEatsToken, true };
Transition GROOVY_DQUOTE_STRING__RETURN = { "\"", &GROOVY_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *GROOVY_TRANSITIONS[] = { &GROOVY_CODE__LINE_COMMENT_0, &GROOVY_LINE_COMMENT__RETURN, &GROOVY_CODE__BLOCK_COMMENT_0, &GROOVY_BLOCK_COMMENT__RETURN_0, &GROOVY_CODE__DQUOTE_STRING, &GROOVY_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &GROOVY_DQUOTE_STRING__DQUOTE_STRING_ESC, &GROOVY_DQUOTE_STRING__RETURN, NULL};
Polyglot GROOVY_POLYGLOT = {
	"groovy",
			GROOVY_STATES,
			GROOVY_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      java
*****************************************************************************/
/* States */
State JAVA_CODE = { "JAVA_CODE", "java", semantic_code };
State JAVA_DQUOTE_STRING = { "JAVA_DQUOTE_STRING", "java", semantic_code };
State JAVA_SQUOTE_STRING = { "JAVA_SQUOTE_STRING", "java", semantic_code };
State JAVA_LINE_COMMENT = { "JAVA_LINE_COMMENT", "java", semantic_comment };
State JAVA_BLOCK_COMMENT = { "JAVA_BLOCK_COMMENT", "java", semantic_comment };
State *JAVA_STATES[] = { &JAVA_CODE, &JAVA_DQUOTE_STRING, &JAVA_SQUOTE_STRING, &JAVA_LINE_COMMENT, &JAVA_BLOCK_COMMENT, NULL };
/* Transitions */
Transition JAVA_CODE__LINE_COMMENT_0 = { "//", &JAVA_CODE, &JAVA_LINE_COMMENT, ToEatsToken, false };
Transition JAVA_LINE_COMMENT__RETURN = { "\n", &JAVA_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition JAVA_CODE__BLOCK_COMMENT_0 = { "/\\*", &JAVA_CODE, &JAVA_BLOCK_COMMENT, ToEatsToken, false };
Transition JAVA_BLOCK_COMMENT__RETURN_0 = { "\\*/", &JAVA_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition JAVA_CODE__DQUOTE_STRING = { "\"", &JAVA_CODE, &JAVA_DQUOTE_STRING, ToEatsToken, false };
Transition JAVA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &JAVA_DQUOTE_STRING, &JAVA_DQUOTE_STRING, ToEatsToken, true };
Transition JAVA_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &JAVA_DQUOTE_STRING, &JAVA_DQUOTE_STRING, ToEatsToken, true };
Transition JAVA_DQUOTE_STRING__RETURN = { "\"", &JAVA_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *JAVA_TRANSITIONS[] = { &JAVA_CODE__LINE_COMMENT_0, &JAVA_LINE_COMMENT__RETURN, &JAVA_CODE__BLOCK_COMMENT_0, &JAVA_BLOCK_COMMENT__RETURN_0, &JAVA_CODE__DQUOTE_STRING, &JAVA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVA_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVA_DQUOTE_STRING__RETURN, NULL};
Polyglot JAVA_POLYGLOT = {
	"java",
			JAVA_STATES,
			JAVA_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                   javascript
*****************************************************************************/
/* States */
State JAVASCRIPT_CODE = { "JAVASCRIPT_CODE", "javascript", semantic_code };
State JAVASCRIPT_DQUOTE_STRING = { "JAVASCRIPT_DQUOTE_STRING", "javascript", semantic_code };
State JAVASCRIPT_SQUOTE_STRING = { "JAVASCRIPT_SQUOTE_STRING", "javascript", semantic_code };
State JAVASCRIPT_LINE_COMMENT = { "JAVASCRIPT_LINE_COMMENT", "javascript", semantic_comment };
State JAVASCRIPT_BLOCK_COMMENT = { "JAVASCRIPT_BLOCK_COMMENT", "javascript", semantic_comment };
State *JAVASCRIPT_STATES[] = { &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_LINE_COMMENT, &JAVASCRIPT_BLOCK_COMMENT, NULL };
/* Transitions */
Transition JAVASCRIPT_CODE__LINE_COMMENT_0 = { "//", &JAVASCRIPT_CODE, &JAVASCRIPT_LINE_COMMENT, ToEatsToken, false };
Transition JAVASCRIPT_LINE_COMMENT__RETURN = { "\n", &JAVASCRIPT_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition JAVASCRIPT_CODE__BLOCK_COMMENT_0 = { "/\\*", &JAVASCRIPT_CODE, &JAVASCRIPT_BLOCK_COMMENT, ToEatsToken, false };
Transition JAVASCRIPT_BLOCK_COMMENT__RETURN_0 = { "\\*/", &JAVASCRIPT_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition JAVASCRIPT_CODE__SQUOTE_STRING = { "'", &JAVASCRIPT_CODE, &JAVASCRIPT_SQUOTE_STRING, ToEatsToken, false };
Transition JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, FromEatsToken, true };
Transition JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, FromEatsToken, true };
Transition JAVASCRIPT_SQUOTE_STRING__RETURN = { "'", &JAVASCRIPT_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition JAVASCRIPT_CODE__DQUOTE_STRING = { "\"", &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, ToEatsToken, false };
Transition JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING, ToEatsToken, true };
Transition JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING, ToEatsToken, true };
Transition JAVASCRIPT_DQUOTE_STRING__RETURN = { "\"", &JAVASCRIPT_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *JAVASCRIPT_TRANSITIONS[] = { &JAVASCRIPT_CODE__LINE_COMMENT_0, &JAVASCRIPT_LINE_COMMENT__RETURN, &JAVASCRIPT_CODE__BLOCK_COMMENT_0, &JAVASCRIPT_BLOCK_COMMENT__RETURN_0, &JAVASCRIPT_CODE__SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC, &JAVASCRIPT_SQUOTE_STRING__RETURN, &JAVASCRIPT_CODE__DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVASCRIPT_DQUOTE_STRING__RETURN, NULL};
Polyglot JAVASCRIPT_POLYGLOT = {
	"javascript",
			JAVASCRIPT_STATES,
			JAVASCRIPT_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                   emacslisp
*****************************************************************************/
/* States */
State EMACSLISP_CODE = { "EMACSLISP_CODE", "emacslisp", semantic_code };
State EMACSLISP_COMMENT = { "EMACSLISP_COMMENT", "emacslisp", semantic_comment };
State *EMACSLISP_STATES[] = { &EMACSLISP_CODE, &EMACSLISP_COMMENT, NULL };
/* Transitions */
Transition EMACSLISP_CODE__COMMENT_0 = { ";", &EMACSLISP_CODE, &EMACSLISP_COMMENT, ToEatsToken, false };
Transition EMACSLISP_COMMENT__RETURN = { "\n", &EMACSLISP_COMMENT, RETURN, FromEatsToken, false };
Transition *EMACSLISP_TRANSITIONS[] = { &EMACSLISP_CODE__COMMENT_0, &EMACSLISP_COMMENT__RETURN, NULL};
Polyglot EMACSLISP_POLYGLOT = {
	"emacslisp",
			EMACSLISP_STATES,
			EMACSLISP_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                    haskell
*****************************************************************************/
/* States */
State HASKELL_CODE = { "HASKELL_CODE", "haskell", semantic_code };
State HASKELL_DQUOTE_STRING = { "HASKELL_DQUOTE_STRING", "haskell", semantic_code };
State HASKELL_SQUOTE_STRING = { "HASKELL_SQUOTE_STRING", "haskell", semantic_code };
State HASKELL_LINE_COMMENT = { "HASKELL_LINE_COMMENT", "haskell", semantic_comment };
State HASKELL_BLOCK_COMMENT = { "HASKELL_BLOCK_COMMENT", "haskell", semantic_comment };
State *HASKELL_STATES[] = { &HASKELL_CODE, &HASKELL_DQUOTE_STRING, &HASKELL_SQUOTE_STRING, &HASKELL_LINE_COMMENT, &HASKELL_BLOCK_COMMENT, NULL };
/* Transitions */
Transition HASKELL_CODE__LINE_COMMENT_0 = { "--", &HASKELL_CODE, &HASKELL_LINE_COMMENT, ToEatsToken, false };
Transition HASKELL_LINE_COMMENT__RETURN = { "\n", &HASKELL_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition HASKELL_CODE__BLOCK_COMMENT_0 = { "{\\-", &HASKELL_CODE, &HASKELL_BLOCK_COMMENT, ToEatsToken, false };
Transition HASKELL_BLOCK_COMMENT__RETURN_0 = { "\\-}", &HASKELL_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition HASKELL_CODE__DQUOTE_STRING = { "\"", &HASKELL_CODE, &HASKELL_DQUOTE_STRING, ToEatsToken, false };
Transition HASKELL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &HASKELL_DQUOTE_STRING, &HASKELL_DQUOTE_STRING, ToEatsToken, true };
Transition HASKELL_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &HASKELL_DQUOTE_STRING, &HASKELL_DQUOTE_STRING, ToEatsToken, true };
Transition HASKELL_DQUOTE_STRING__RETURN = { "\"", &HASKELL_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *HASKELL_TRANSITIONS[] = { &HASKELL_CODE__LINE_COMMENT_0, &HASKELL_LINE_COMMENT__RETURN, &HASKELL_CODE__BLOCK_COMMENT_0, &HASKELL_BLOCK_COMMENT__RETURN_0, &HASKELL_CODE__DQUOTE_STRING, &HASKELL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &HASKELL_DQUOTE_STRING__DQUOTE_STRING_ESC, &HASKELL_DQUOTE_STRING__RETURN, NULL};
Polyglot HASKELL_POLYGLOT = {
	"haskell",
			HASKELL_STATES,
			HASKELL_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      lisp
*****************************************************************************/
/* States */
State LISP_CODE = { "LISP_CODE", "lisp", semantic_code };
State LISP_COMMENT = { "LISP_COMMENT", "lisp", semantic_comment };
State *LISP_STATES[] = { &LISP_CODE, &LISP_COMMENT, NULL };
/* Transitions */
Transition LISP_CODE__COMMENT_0 = { ";", &LISP_CODE, &LISP_COMMENT, ToEatsToken, false };
Transition LISP_COMMENT__RETURN = { "\n", &LISP_COMMENT, RETURN, FromEatsToken, false };
Transition *LISP_TRANSITIONS[] = { &LISP_CODE__COMMENT_0, &LISP_COMMENT__RETURN, NULL};
Polyglot LISP_POLYGLOT = {
	"lisp",
			LISP_STATES,
			LISP_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      lua
*****************************************************************************/
/* States */
State LUA_CODE = { "LUA_CODE", "lua", semantic_code };
State LUA_DQUOTE_STRING = { "LUA_DQUOTE_STRING", "lua", semantic_code };
State LUA_SQUOTE_STRING = { "LUA_SQUOTE_STRING", "lua", semantic_code };
State LUA_LINE_COMMENT = { "LUA_LINE_COMMENT", "lua", semantic_comment };
State LUA_BLOCK_COMMENT = { "LUA_BLOCK_COMMENT", "lua", semantic_comment };
State *LUA_STATES[] = { &LUA_CODE, &LUA_DQUOTE_STRING, &LUA_SQUOTE_STRING, &LUA_LINE_COMMENT, &LUA_BLOCK_COMMENT, NULL };
/* Transitions */
Transition LUA_CODE__LINE_COMMENT_0 = { "--", &LUA_CODE, &LUA_LINE_COMMENT, ToEatsToken, false };
Transition LUA_LINE_COMMENT__RETURN = { "\n", &LUA_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition LUA_CODE__SQUOTE_STRING = { "'", &LUA_CODE, &LUA_SQUOTE_STRING, ToEatsToken, false };
Transition LUA_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &LUA_SQUOTE_STRING, &LUA_SQUOTE_STRING, FromEatsToken, true };
Transition LUA_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &LUA_SQUOTE_STRING, &LUA_SQUOTE_STRING, FromEatsToken, true };
Transition LUA_SQUOTE_STRING__RETURN = { "'", &LUA_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition LUA_CODE__DQUOTE_STRING = { "\"", &LUA_CODE, &LUA_DQUOTE_STRING, ToEatsToken, false };
Transition LUA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &LUA_DQUOTE_STRING, &LUA_DQUOTE_STRING, ToEatsToken, true };
Transition LUA_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &LUA_DQUOTE_STRING, &LUA_DQUOTE_STRING, ToEatsToken, true };
Transition LUA_DQUOTE_STRING__RETURN = { "\"", &LUA_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *LUA_TRANSITIONS[] = { &LUA_CODE__LINE_COMMENT_0, &LUA_LINE_COMMENT__RETURN, &LUA_CODE__SQUOTE_STRING, &LUA_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &LUA_SQUOTE_STRING__SQUOTE_STRING_ESC, &LUA_SQUOTE_STRING__RETURN, &LUA_CODE__DQUOTE_STRING, &LUA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &LUA_DQUOTE_STRING__DQUOTE_STRING_ESC, &LUA_DQUOTE_STRING__RETURN, NULL};
Polyglot LUA_POLYGLOT = {
	"lua",
			LUA_STATES,
			LUA_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     matlab
*****************************************************************************/
/* States */
State MATLAB_CODE = { "MATLAB_CODE", "matlab", semantic_code };
State MATLAB_DQUOTE_STRING = { "MATLAB_DQUOTE_STRING", "matlab", semantic_code };
State MATLAB_SQUOTE_STRING = { "MATLAB_SQUOTE_STRING", "matlab", semantic_code };
State MATLAB_LINE_COMMENT = { "MATLAB_LINE_COMMENT", "matlab", semantic_comment };
State MATLAB_BLOCK_COMMENT = { "MATLAB_BLOCK_COMMENT", "matlab", semantic_comment };
State *MATLAB_STATES[] = { &MATLAB_CODE, &MATLAB_DQUOTE_STRING, &MATLAB_SQUOTE_STRING, &MATLAB_LINE_COMMENT, &MATLAB_BLOCK_COMMENT, NULL };
/* Transitions */
Transition MATLAB_CODE__LINE_COMMENT_0 = { "#|%", &MATLAB_CODE, &MATLAB_LINE_COMMENT, ToEatsToken, false };
Transition MATLAB_LINE_COMMENT__RETURN = { "\n", &MATLAB_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition MATLAB_CODE__BLOCK_COMMENT_0 = { "{%", &MATLAB_CODE, &MATLAB_BLOCK_COMMENT, ToEatsToken, false };
Transition MATLAB_BLOCK_COMMENT__RETURN_0 = { "%}", &MATLAB_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition MATLAB_CODE__SQUOTE_STRING = { "'", &MATLAB_CODE, &MATLAB_SQUOTE_STRING, ToEatsToken, false };
Transition MATLAB_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &MATLAB_SQUOTE_STRING, &MATLAB_SQUOTE_STRING, FromEatsToken, true };
Transition MATLAB_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &MATLAB_SQUOTE_STRING, &MATLAB_SQUOTE_STRING, FromEatsToken, true };
Transition MATLAB_SQUOTE_STRING__RETURN = { "'", &MATLAB_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *MATLAB_TRANSITIONS[] = { &MATLAB_CODE__LINE_COMMENT_0, &MATLAB_LINE_COMMENT__RETURN, &MATLAB_CODE__BLOCK_COMMENT_0, &MATLAB_BLOCK_COMMENT__RETURN_0, &MATLAB_CODE__SQUOTE_STRING, &MATLAB_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &MATLAB_SQUOTE_STRING__SQUOTE_STRING_ESC, &MATLAB_SQUOTE_STRING__RETURN, NULL};
Polyglot MATLAB_POLYGLOT = {
	"matlab",
			MATLAB_STATES,
			MATLAB_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                  objective_c
*****************************************************************************/
/* States */
State OBJECTIVE_C_CODE = { "OBJECTIVE_C_CODE", "objective_c", semantic_code };
State OBJECTIVE_C_DQUOTE_STRING = { "OBJECTIVE_C_DQUOTE_STRING", "objective_c", semantic_code };
State OBJECTIVE_C_SQUOTE_STRING = { "OBJECTIVE_C_SQUOTE_STRING", "objective_c", semantic_code };
State OBJECTIVE_C_LINE_COMMENT = { "OBJECTIVE_C_LINE_COMMENT", "objective_c", semantic_comment };
State OBJECTIVE_C_BLOCK_COMMENT = { "OBJECTIVE_C_BLOCK_COMMENT", "objective_c", semantic_comment };
State *OBJECTIVE_C_STATES[] = { &OBJECTIVE_C_CODE, &OBJECTIVE_C_DQUOTE_STRING, &OBJECTIVE_C_SQUOTE_STRING, &OBJECTIVE_C_LINE_COMMENT, &OBJECTIVE_C_BLOCK_COMMENT, NULL };
/* Transitions */
Transition OBJECTIVE_C_CODE__LINE_COMMENT_0 = { "//", &OBJECTIVE_C_CODE, &OBJECTIVE_C_LINE_COMMENT, ToEatsToken, false };
Transition OBJECTIVE_C_LINE_COMMENT__RETURN = { "\n", &OBJECTIVE_C_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition OBJECTIVE_C_CODE__BLOCK_COMMENT_0 = { "/\\*", &OBJECTIVE_C_CODE, &OBJECTIVE_C_BLOCK_COMMENT, ToEatsToken, false };
Transition OBJECTIVE_C_BLOCK_COMMENT__RETURN_0 = { "\\*/", &OBJECTIVE_C_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition OBJECTIVE_C_CODE__DQUOTE_STRING = { "\"", &OBJECTIVE_C_CODE, &OBJECTIVE_C_DQUOTE_STRING, ToEatsToken, false };
Transition OBJECTIVE_C_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &OBJECTIVE_C_DQUOTE_STRING, &OBJECTIVE_C_DQUOTE_STRING, ToEatsToken, true };
Transition OBJECTIVE_C_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &OBJECTIVE_C_DQUOTE_STRING, &OBJECTIVE_C_DQUOTE_STRING, ToEatsToken, true };
Transition OBJECTIVE_C_DQUOTE_STRING__RETURN = { "\"", &OBJECTIVE_C_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *OBJECTIVE_C_TRANSITIONS[] = { &OBJECTIVE_C_CODE__LINE_COMMENT_0, &OBJECTIVE_C_LINE_COMMENT__RETURN, &OBJECTIVE_C_CODE__BLOCK_COMMENT_0, &OBJECTIVE_C_BLOCK_COMMENT__RETURN_0, &OBJECTIVE_C_CODE__DQUOTE_STRING, &OBJECTIVE_C_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &OBJECTIVE_C_DQUOTE_STRING__DQUOTE_STRING_ESC, &OBJECTIVE_C_DQUOTE_STRING__RETURN, NULL};
Polyglot OBJECTIVE_C_POLYGLOT = {
	"objective_c",
			OBJECTIVE_C_STATES,
			OBJECTIVE_C_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     pascal
*****************************************************************************/
/* States */
State PASCAL_CODE = { "PASCAL_CODE", "pascal", semantic_code };
State PASCAL_DQUOTE_STRING = { "PASCAL_DQUOTE_STRING", "pascal", semantic_code };
State PASCAL_SQUOTE_STRING = { "PASCAL_SQUOTE_STRING", "pascal", semantic_code };
State PASCAL_LINE_COMMENT = { "PASCAL_LINE_COMMENT", "pascal", semantic_comment };
State PASCAL_BLOCK_COMMENT = { "PASCAL_BLOCK_COMMENT", "pascal", semantic_comment };
State *PASCAL_STATES[] = { &PASCAL_CODE, &PASCAL_DQUOTE_STRING, &PASCAL_SQUOTE_STRING, &PASCAL_LINE_COMMENT, &PASCAL_BLOCK_COMMENT, NULL };
/* Transitions */
Transition PASCAL_CODE__LINE_COMMENT_0 = { "//", &PASCAL_CODE, &PASCAL_LINE_COMMENT, ToEatsToken, false };
Transition PASCAL_LINE_COMMENT__RETURN = { "\n", &PASCAL_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition PASCAL_CODE__BLOCK_COMMENT_0 = { "{", &PASCAL_CODE, &PASCAL_BLOCK_COMMENT, ToEatsToken, false };
Transition PASCAL_BLOCK_COMMENT__RETURN_0 = { "}", &PASCAL_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition PASCAL_CODE__DQUOTE_STRING = { "\"", &PASCAL_CODE, &PASCAL_DQUOTE_STRING, ToEatsToken, false };
Transition PASCAL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &PASCAL_DQUOTE_STRING, &PASCAL_DQUOTE_STRING, ToEatsToken, true };
Transition PASCAL_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &PASCAL_DQUOTE_STRING, &PASCAL_DQUOTE_STRING, ToEatsToken, true };
Transition PASCAL_DQUOTE_STRING__RETURN = { "\"", &PASCAL_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *PASCAL_TRANSITIONS[] = { &PASCAL_CODE__LINE_COMMENT_0, &PASCAL_LINE_COMMENT__RETURN, &PASCAL_CODE__BLOCK_COMMENT_0, &PASCAL_BLOCK_COMMENT__RETURN_0, &PASCAL_CODE__DQUOTE_STRING, &PASCAL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &PASCAL_DQUOTE_STRING__DQUOTE_STRING_ESC, &PASCAL_DQUOTE_STRING__RETURN, NULL};
Polyglot PASCAL_POLYGLOT = {
	"pascal",
			PASCAL_STATES,
			PASCAL_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      perl
*****************************************************************************/
/* States */
State PERL_CODE = { "PERL_CODE", "perl", semantic_code };
State PERL_DQUOTE_STRING = { "PERL_DQUOTE_STRING", "perl", semantic_code };
State PERL_SQUOTE_STRING = { "PERL_SQUOTE_STRING", "perl", semantic_code };
State PERL_LINE_COMMENT = { "PERL_LINE_COMMENT", "perl", semantic_comment };
State PERL_BLOCK_COMMENT = { "PERL_BLOCK_COMMENT", "perl", semantic_comment };
State *PERL_STATES[] = { &PERL_CODE, &PERL_DQUOTE_STRING, &PERL_SQUOTE_STRING, &PERL_LINE_COMMENT, &PERL_BLOCK_COMMENT, NULL };
/* Transitions */
Transition PERL_CODE__LINE_COMMENT_0 = { "#", &PERL_CODE, &PERL_LINE_COMMENT, ToEatsToken, false };
Transition PERL_LINE_COMMENT__RETURN = { "\n", &PERL_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition PERL_CODE__SQUOTE_STRING = { "'", &PERL_CODE, &PERL_SQUOTE_STRING, ToEatsToken, false };
Transition PERL_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &PERL_SQUOTE_STRING, &PERL_SQUOTE_STRING, FromEatsToken, true };
Transition PERL_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &PERL_SQUOTE_STRING, &PERL_SQUOTE_STRING, FromEatsToken, true };
Transition PERL_SQUOTE_STRING__RETURN = { "'", &PERL_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition PERL_CODE__DQUOTE_STRING = { "\"", &PERL_CODE, &PERL_DQUOTE_STRING, ToEatsToken, false };
Transition PERL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &PERL_DQUOTE_STRING, &PERL_DQUOTE_STRING, ToEatsToken, true };
Transition PERL_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &PERL_DQUOTE_STRING, &PERL_DQUOTE_STRING, ToEatsToken, true };
Transition PERL_DQUOTE_STRING__RETURN = { "\"", &PERL_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *PERL_TRANSITIONS[] = { &PERL_CODE__LINE_COMMENT_0, &PERL_LINE_COMMENT__RETURN, &PERL_CODE__SQUOTE_STRING, &PERL_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &PERL_SQUOTE_STRING__SQUOTE_STRING_ESC, &PERL_SQUOTE_STRING__RETURN, &PERL_CODE__DQUOTE_STRING, &PERL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &PERL_DQUOTE_STRING__DQUOTE_STRING_ESC, &PERL_DQUOTE_STRING__RETURN, NULL};
Polyglot PERL_POLYGLOT = {
	"perl",
			PERL_STATES,
			PERL_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                  phplanguage
*****************************************************************************/
/* States */
State PHP_CODE = { "PHP_CODE", "php", semantic_code };
State PHP_DQUOTE_STRING = { "PHP_DQUOTE_STRING", "php", semantic_code };
State PHP_SQUOTE_STRING = { "PHP_SQUOTE_STRING", "php", semantic_code };
State PHP_LINE_COMMENT = { "PHP_LINE_COMMENT", "php", semantic_comment };
State PHP_BLOCK_COMMENT = { "PHP_BLOCK_COMMENT", "php", semantic_comment };
State *PHPLANGUAGE_STATES[] = { &PHP_CODE, &PHP_DQUOTE_STRING, &PHP_SQUOTE_STRING, &PHP_LINE_COMMENT, &PHP_BLOCK_COMMENT, NULL };
/* Transitions */
Transition PHP_CODE__LINE_COMMENT_0 = { "//", &PHP_CODE, &PHP_LINE_COMMENT, ToEatsToken, false };
Transition PHP_LINE_COMMENT__RETURN = { "\n", &PHP_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition PHP_CODE__BLOCK_COMMENT_0 = { "/\\*", &PHP_CODE, &PHP_BLOCK_COMMENT, ToEatsToken, false };
Transition PHP_BLOCK_COMMENT__RETURN_0 = { "\\*/", &PHP_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition PHP_CODE__SQUOTE_STRING = { "'", &PHP_CODE, &PHP_SQUOTE_STRING, ToEatsToken, false };
Transition PHP_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &PHP_SQUOTE_STRING, &PHP_SQUOTE_STRING, FromEatsToken, true };
Transition PHP_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &PHP_SQUOTE_STRING, &PHP_SQUOTE_STRING, FromEatsToken, true };
Transition PHP_SQUOTE_STRING__RETURN = { "'", &PHP_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition PHP_CODE__DQUOTE_STRING = { "\"", &PHP_CODE, &PHP_DQUOTE_STRING, ToEatsToken, false };
Transition PHP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &PHP_DQUOTE_STRING, &PHP_DQUOTE_STRING, ToEatsToken, true };
Transition PHP_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &PHP_DQUOTE_STRING, &PHP_DQUOTE_STRING, ToEatsToken, true };
Transition PHP_DQUOTE_STRING__RETURN = { "\"", &PHP_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *PHPLANGUAGE_TRANSITIONS[] = { &PHP_CODE__LINE_COMMENT_0, &PHP_LINE_COMMENT__RETURN, &PHP_CODE__BLOCK_COMMENT_0, &PHP_BLOCK_COMMENT__RETURN_0, &PHP_CODE__SQUOTE_STRING, &PHP_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &PHP_SQUOTE_STRING__SQUOTE_STRING_ESC, &PHP_SQUOTE_STRING__RETURN, &PHP_CODE__DQUOTE_STRING, &PHP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &PHP_DQUOTE_STRING__DQUOTE_STRING_ESC, &PHP_DQUOTE_STRING__RETURN, NULL};
Polyglot PHPLANGUAGE_POLYGLOT = {
	"phplanguage",
			PHPLANGUAGE_STATES,
			PHPLANGUAGE_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     python
*****************************************************************************/
/* States */
State PYTHON_CODE = { "PYTHON_CODE", "python", semantic_code };
State PYTHON_MULTI_LINE_SQUOTE = { "PYTHON_MULTI_LINE_SQUOTE", "python", semantic_code };
State PYTHON_MULTI_LINE_DQUOTE = { "PYTHON_MULTI_LINE_DQUOTE", "python", semantic_code };
State PYTHON_RAW_DQUOTE = { "PYTHON_RAW_DQUOTE", "python", semantic_code };
State PYTHON_SQUOTE = { "PYTHON_SQUOTE", "python", semantic_code };
State PYTHON_DQUOTE = { "PYTHON_DQUOTE", "python", semantic_code };
State PYTHON_LINE_COMMENT = { "PYTHON_LINE_COMMENT", "python", semantic_comment };
State *PYTHON_STATES[] = { &PYTHON_CODE, &PYTHON_MULTI_LINE_SQUOTE, &PYTHON_MULTI_LINE_DQUOTE, &PYTHON_RAW_DQUOTE, &PYTHON_SQUOTE, &PYTHON_DQUOTE, &PYTHON_LINE_COMMENT, NULL };
/* Transitions */
Transition PYTHON_CODE__MULTI_LINE_SQUOTE = { "'''", &PYTHON_CODE, &PYTHON_MULTI_LINE_SQUOTE, FromEatsToken, false };
Transition PYTHON_MULTI_LINE_SQUOTE__RETURN = { "'''", &PYTHON_MULTI_LINE_SQUOTE, RETURN, FromEatsToken, false };
Transition PYTHON_CODE__MULTI_LINE_DQUOTE = { "\"\"\"", &PYTHON_CODE, &PYTHON_MULTI_LINE_DQUOTE, FromEatsToken, false };
Transition PYTHON_MULTI_LINE_DQUOTE__RETURN = { "\"\"\"", &PYTHON_MULTI_LINE_DQUOTE, RETURN, FromEatsToken, false };
Transition PYTHON_CODE__RAW_DQUOTE = { "r\"", &PYTHON_CODE, &PYTHON_RAW_DQUOTE, FromEatsToken, false };
Transition PYTHON_RAW_DQUOTE__RETURN = { "\"", &PYTHON_RAW_DQUOTE, RETURN, FromEatsToken, false };
Transition PYTHON_CODE__SQUOTE = { "'", &PYTHON_CODE, &PYTHON_SQUOTE, FromEatsToken, false };
Transition PYTHON_SQUOTE__RETURN_ESC = { "\\\\'", &PYTHON_SQUOTE, RETURN, FromEatsToken, true };
Transition PYTHON_SQUOTE__RETURN = { "'", &PYTHON_SQUOTE, RETURN, ToEatsToken, false };
Transition PYTHON_CODE__DQUOTE = { "\"", &PYTHON_CODE, &PYTHON_DQUOTE, ToEatsToken, false };
Transition PYTHON_DQUOTE__RETURN_ESC = { "\\\\\"", &PYTHON_DQUOTE, RETURN, FromEatsToken, true };
Transition PYTHON_DQUOTE__RETURN = { "\"", &PYTHON_DQUOTE, RETURN, ToEatsToken, false };
Transition PYTHON_CODE__LINE_COMMENT = { "#", &PYTHON_CODE, &PYTHON_LINE_COMMENT, ToEatsToken, false };
Transition PYTHON_LINE_COMMENT__RETURN = { "\n", &PYTHON_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition *PYTHON_TRANSITIONS[] = { &PYTHON_CODE__MULTI_LINE_SQUOTE, &PYTHON_MULTI_LINE_SQUOTE__RETURN, &PYTHON_CODE__MULTI_LINE_DQUOTE, &PYTHON_MULTI_LINE_DQUOTE__RETURN, &PYTHON_CODE__RAW_DQUOTE, &PYTHON_RAW_DQUOTE__RETURN, &PYTHON_CODE__SQUOTE, &PYTHON_SQUOTE__RETURN_ESC, &PYTHON_SQUOTE__RETURN, &PYTHON_CODE__DQUOTE, &PYTHON_DQUOTE__RETURN_ESC, &PYTHON_DQUOTE__RETURN, &PYTHON_CODE__LINE_COMMENT, &PYTHON_LINE_COMMENT__RETURN, NULL};
Polyglot PYTHON_POLYGLOT = {
	"python",
			PYTHON_STATES,
			PYTHON_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      ruby
*****************************************************************************/
/* States */
State RUBY_CODE = { "RUBY_CODE", "ruby", semantic_code };
State RUBY_DQUOTE_STRING = { "RUBY_DQUOTE_STRING", "ruby", semantic_code };
State RUBY_SQUOTE_STRING = { "RUBY_SQUOTE_STRING", "ruby", semantic_code };
State RUBY_LINE_COMMENT = { "RUBY_LINE_COMMENT", "ruby", semantic_comment };
State RUBY_BLOCK_COMMENT = { "RUBY_BLOCK_COMMENT", "ruby", semantic_comment };
State *RUBY_STATES[] = { &RUBY_CODE, &RUBY_DQUOTE_STRING, &RUBY_SQUOTE_STRING, &RUBY_LINE_COMMENT, &RUBY_BLOCK_COMMENT, NULL };
/* Transitions */
Transition RUBY_CODE__LINE_COMMENT_0 = { "#", &RUBY_CODE, &RUBY_LINE_COMMENT, ToEatsToken, false };
Transition RUBY_LINE_COMMENT__RETURN = { "\n", &RUBY_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition RUBY_CODE__SQUOTE_STRING = { "'", &RUBY_CODE, &RUBY_SQUOTE_STRING, ToEatsToken, false };
Transition RUBY_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &RUBY_SQUOTE_STRING, &RUBY_SQUOTE_STRING, FromEatsToken, true };
Transition RUBY_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &RUBY_SQUOTE_STRING, &RUBY_SQUOTE_STRING, FromEatsToken, true };
Transition RUBY_SQUOTE_STRING__RETURN = { "'", &RUBY_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition RUBY_CODE__DQUOTE_STRING = { "\"", &RUBY_CODE, &RUBY_DQUOTE_STRING, ToEatsToken, false };
Transition RUBY_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &RUBY_DQUOTE_STRING, &RUBY_DQUOTE_STRING, ToEatsToken, true };
Transition RUBY_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &RUBY_DQUOTE_STRING, &RUBY_DQUOTE_STRING, ToEatsToken, true };
Transition RUBY_DQUOTE_STRING__RETURN = { "\"", &RUBY_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *RUBY_TRANSITIONS[] = { &RUBY_CODE__LINE_COMMENT_0, &RUBY_LINE_COMMENT__RETURN, &RUBY_CODE__SQUOTE_STRING, &RUBY_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &RUBY_SQUOTE_STRING__SQUOTE_STRING_ESC, &RUBY_SQUOTE_STRING__RETURN, &RUBY_CODE__DQUOTE_STRING, &RUBY_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &RUBY_DQUOTE_STRING__DQUOTE_STRING_ESC, &RUBY_DQUOTE_STRING__RETURN, NULL};
Polyglot RUBY_POLYGLOT = {
	"ruby",
			RUBY_STATES,
			RUBY_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      rexx
*****************************************************************************/
/* States */
State REXX_CODE = { "REXX_CODE", "rexx", semantic_code };
State REXX_DQUOTE_STRING = { "REXX_DQUOTE_STRING", "rexx", semantic_code };
State REXX_SQUOTE_STRING = { "REXX_SQUOTE_STRING", "rexx", semantic_code };
State REXX_LINE_COMMENT = { "REXX_LINE_COMMENT", "rexx", semantic_comment };
State REXX_BLOCK_COMMENT = { "REXX_BLOCK_COMMENT", "rexx", semantic_comment };
State *REXX_STATES[] = { &REXX_CODE, &REXX_DQUOTE_STRING, &REXX_SQUOTE_STRING, &REXX_LINE_COMMENT, &REXX_BLOCK_COMMENT, NULL };
/* Transitions */
Transition REXX_CODE__BLOCK_COMMENT_0 = { "/\\*", &REXX_CODE, &REXX_BLOCK_COMMENT, ToEatsToken, false };
Transition REXX_BLOCK_COMMENT__RETURN_0 = { "\\*/", &REXX_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition REXX_CODE__SQUOTE_STRING = { "'", &REXX_CODE, &REXX_SQUOTE_STRING, ToEatsToken, false };
Transition REXX_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &REXX_SQUOTE_STRING, &REXX_SQUOTE_STRING, FromEatsToken, true };
Transition REXX_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &REXX_SQUOTE_STRING, &REXX_SQUOTE_STRING, FromEatsToken, true };
Transition REXX_SQUOTE_STRING__RETURN = { "'", &REXX_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition REXX_CODE__DQUOTE_STRING = { "\"", &REXX_CODE, &REXX_DQUOTE_STRING, ToEatsToken, false };
Transition REXX_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &REXX_DQUOTE_STRING, &REXX_DQUOTE_STRING, ToEatsToken, true };
Transition REXX_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &REXX_DQUOTE_STRING, &REXX_DQUOTE_STRING, ToEatsToken, true };
Transition REXX_DQUOTE_STRING__RETURN = { "\"", &REXX_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *REXX_TRANSITIONS[] = { &REXX_CODE__BLOCK_COMMENT_0, &REXX_BLOCK_COMMENT__RETURN_0, &REXX_CODE__SQUOTE_STRING, &REXX_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &REXX_SQUOTE_STRING__SQUOTE_STRING_ESC, &REXX_SQUOTE_STRING__RETURN, &REXX_CODE__DQUOTE_STRING, &REXX_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &REXX_DQUOTE_STRING__DQUOTE_STRING_ESC, &REXX_DQUOTE_STRING__RETURN, NULL};
Polyglot REXX_POLYGLOT = {
	"rexx",
			REXX_STATES,
			REXX_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     scheme
*****************************************************************************/
/* States */
State SCHEME_CODE = { "SCHEME_CODE", "scheme", semantic_code };
State SCHEME_COMMENT = { "SCHEME_COMMENT", "scheme", semantic_comment };
State *SCHEME_STATES[] = { &SCHEME_CODE, &SCHEME_COMMENT, NULL };
/* Transitions */
Transition SCHEME_CODE__COMMENT_0 = { ";", &SCHEME_CODE, &SCHEME_COMMENT, ToEatsToken, false };
Transition SCHEME_COMMENT__RETURN = { "\n", &SCHEME_COMMENT, RETURN, FromEatsToken, false };
Transition *SCHEME_TRANSITIONS[] = { &SCHEME_CODE__COMMENT_0, &SCHEME_COMMENT__RETURN, NULL};
Polyglot SCHEME_POLYGLOT = {
	"scheme",
			SCHEME_STATES,
			SCHEME_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     shell
*****************************************************************************/
/* States */
State SHELL_CODE = { "SHELL_CODE", "shell", semantic_code };
State SHELL_DQUOTE_STRING = { "SHELL_DQUOTE_STRING", "shell", semantic_code };
State SHELL_SQUOTE_STRING = { "SHELL_SQUOTE_STRING", "shell", semantic_code };
State SHELL_LINE_COMMENT = { "SHELL_LINE_COMMENT", "shell", semantic_comment };
State SHELL_BLOCK_COMMENT = { "SHELL_BLOCK_COMMENT", "shell", semantic_comment };
State *SHELL_STATES[] = { &SHELL_CODE, &SHELL_DQUOTE_STRING, &SHELL_SQUOTE_STRING, &SHELL_LINE_COMMENT, &SHELL_BLOCK_COMMENT, NULL };
/* Transitions */
Transition SHELL_CODE__LINE_COMMENT_0 = { "#", &SHELL_CODE, &SHELL_LINE_COMMENT, ToEatsToken, false };
Transition SHELL_LINE_COMMENT__RETURN = { "\n", &SHELL_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition *SHELL_TRANSITIONS[] = { &SHELL_CODE__LINE_COMMENT_0, &SHELL_LINE_COMMENT__RETURN, NULL};
Polyglot SHELL_POLYGLOT = {
	"shell",
			SHELL_STATES,
			SHELL_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      sql
*****************************************************************************/
/* States */
State SQL_CODE = { "SQL_CODE", "sql", semantic_code };
State SQL_DQUOTE_STRING = { "SQL_DQUOTE_STRING", "sql", semantic_code };
State SQL_SQUOTE_STRING = { "SQL_SQUOTE_STRING", "sql", semantic_code };
State SQL_LINE_COMMENT = { "SQL_LINE_COMMENT", "sql", semantic_comment };
State SQL_BLOCK_COMMENT = { "SQL_BLOCK_COMMENT", "sql", semantic_comment };
State *SQL_STATES[] = { &SQL_CODE, &SQL_DQUOTE_STRING, &SQL_SQUOTE_STRING, &SQL_LINE_COMMENT, &SQL_BLOCK_COMMENT, NULL };
/* Transitions */
Transition SQL_CODE__LINE_COMMENT_0 = { "--", &SQL_CODE, &SQL_LINE_COMMENT, ToEatsToken, false };
Transition SQL_CODE__LINE_COMMENT_1 = { "//", &SQL_CODE, &SQL_LINE_COMMENT, ToEatsToken, false };
Transition SQL_LINE_COMMENT__RETURN = { "\n", &SQL_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition SQL_CODE__BLOCK_COMMENT_0 = { "{", &SQL_CODE, &SQL_BLOCK_COMMENT, ToEatsToken, false };
Transition SQL_BLOCK_COMMENT__RETURN_0 = { "}", &SQL_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition SQL_CODE__BLOCK_COMMENT_1 = { "/\\*", &SQL_CODE, &SQL_BLOCK_COMMENT, ToEatsToken, false };
Transition SQL_BLOCK_COMMENT__RETURN_1 = { "\\*/", &SQL_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition SQL_CODE__SQUOTE_STRING = { "'", &SQL_CODE, &SQL_SQUOTE_STRING, ToEatsToken, false };
Transition SQL_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &SQL_SQUOTE_STRING, &SQL_SQUOTE_STRING, FromEatsToken, true };
Transition SQL_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &SQL_SQUOTE_STRING, &SQL_SQUOTE_STRING, FromEatsToken, true };
Transition SQL_SQUOTE_STRING__RETURN = { "'", &SQL_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition SQL_CODE__DQUOTE_STRING = { "\"", &SQL_CODE, &SQL_DQUOTE_STRING, ToEatsToken, false };
Transition SQL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &SQL_DQUOTE_STRING, &SQL_DQUOTE_STRING, ToEatsToken, true };
Transition SQL_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &SQL_DQUOTE_STRING, &SQL_DQUOTE_STRING, ToEatsToken, true };
Transition SQL_DQUOTE_STRING__RETURN = { "\"", &SQL_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *SQL_TRANSITIONS[] = { &SQL_CODE__LINE_COMMENT_0, &SQL_CODE__LINE_COMMENT_1, &SQL_LINE_COMMENT__RETURN, &SQL_CODE__BLOCK_COMMENT_0, &SQL_BLOCK_COMMENT__RETURN_0, &SQL_CODE__BLOCK_COMMENT_1, &SQL_BLOCK_COMMENT__RETURN_1, &SQL_CODE__SQUOTE_STRING, &SQL_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &SQL_SQUOTE_STRING__SQUOTE_STRING_ESC, &SQL_SQUOTE_STRING__RETURN, &SQL_CODE__DQUOTE_STRING, &SQL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &SQL_DQUOTE_STRING__DQUOTE_STRING_ESC, &SQL_DQUOTE_STRING__RETURN, NULL};
Polyglot SQL_POLYGLOT = {
	"sql",
			SQL_STATES,
			SQL_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      tcl
*****************************************************************************/
/* States */
State TCL_CODE = { "TCL_CODE", "tcl", semantic_code };
State TCL_DQUOTE_STRING = { "TCL_DQUOTE_STRING", "tcl", semantic_code };
State TCL_SQUOTE_STRING = { "TCL_SQUOTE_STRING", "tcl", semantic_code };
State TCL_LINE_COMMENT = { "TCL_LINE_COMMENT", "tcl", semantic_comment };
State TCL_BLOCK_COMMENT = { "TCL_BLOCK_COMMENT", "tcl", semantic_comment };
State *TCL_STATES[] = { &TCL_CODE, &TCL_DQUOTE_STRING, &TCL_SQUOTE_STRING, &TCL_LINE_COMMENT, &TCL_BLOCK_COMMENT, NULL };
/* Transitions */
Transition TCL_CODE__LINE_COMMENT_0 = { "#", &TCL_CODE, &TCL_LINE_COMMENT, ToEatsToken, false };
Transition TCL_LINE_COMMENT__RETURN = { "\n", &TCL_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition TCL_CODE__DQUOTE_STRING = { "\"", &TCL_CODE, &TCL_DQUOTE_STRING, ToEatsToken, false };
Transition TCL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &TCL_DQUOTE_STRING, &TCL_DQUOTE_STRING, ToEatsToken, true };
Transition TCL_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &TCL_DQUOTE_STRING, &TCL_DQUOTE_STRING, ToEatsToken, true };
Transition TCL_DQUOTE_STRING__RETURN = { "\"", &TCL_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *TCL_TRANSITIONS[] = { &TCL_CODE__LINE_COMMENT_0, &TCL_LINE_COMMENT__RETURN, &TCL_CODE__DQUOTE_STRING, &TCL_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &TCL_DQUOTE_STRING__DQUOTE_STRING_ESC, &TCL_DQUOTE_STRING__RETURN, NULL};
Polyglot TCL_POLYGLOT = {
	"tcl",
			TCL_STATES,
			TCL_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      vala
*****************************************************************************/
/* States */
State VALA_CODE = { "VALA_CODE", "vala", semantic_code };
State VALA_DQUOTE_STRING = { "VALA_DQUOTE_STRING", "vala", semantic_code };
State VALA_SQUOTE_STRING = { "VALA_SQUOTE_STRING", "vala", semantic_code };
State VALA_LINE_COMMENT = { "VALA_LINE_COMMENT", "vala", semantic_comment };
State VALA_BLOCK_COMMENT = { "VALA_BLOCK_COMMENT", "vala", semantic_comment };
State *VALA_STATES[] = { &VALA_CODE, &VALA_DQUOTE_STRING, &VALA_SQUOTE_STRING, &VALA_LINE_COMMENT, &VALA_BLOCK_COMMENT, NULL };
/* Transitions */
Transition VALA_CODE__LINE_COMMENT_0 = { "//", &VALA_CODE, &VALA_LINE_COMMENT, ToEatsToken, false };
Transition VALA_LINE_COMMENT__RETURN = { "\n", &VALA_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition VALA_CODE__BLOCK_COMMENT_0 = { "/\\*", &VALA_CODE, &VALA_BLOCK_COMMENT, ToEatsToken, false };
Transition VALA_BLOCK_COMMENT__RETURN_0 = { "\\*/", &VALA_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition VALA_CODE__DQUOTE_STRING = { "\"", &VALA_CODE, &VALA_DQUOTE_STRING, ToEatsToken, false };
Transition VALA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &VALA_DQUOTE_STRING, &VALA_DQUOTE_STRING, ToEatsToken, true };
Transition VALA_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &VALA_DQUOTE_STRING, &VALA_DQUOTE_STRING, ToEatsToken, true };
Transition VALA_DQUOTE_STRING__RETURN = { "\"", &VALA_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *VALA_TRANSITIONS[] = { &VALA_CODE__LINE_COMMENT_0, &VALA_LINE_COMMENT__RETURN, &VALA_CODE__BLOCK_COMMENT_0, &VALA_BLOCK_COMMENT__RETURN_0, &VALA_CODE__DQUOTE_STRING, &VALA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &VALA_DQUOTE_STRING__DQUOTE_STRING_ESC, &VALA_DQUOTE_STRING__RETURN, NULL};
Polyglot VALA_POLYGLOT = {
	"vala",
			VALA_STATES,
			VALA_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                  visualbasic
*****************************************************************************/
/* States */
State VISUALBASIC_CODE = { "VISUALBASIC_CODE", "visualbasic", semantic_code };
State VISUALBASIC_DQUOTE_STRING = { "VISUALBASIC_DQUOTE_STRING", "visualbasic", semantic_code };
State VISUALBASIC_SQUOTE_STRING = { "VISUALBASIC_SQUOTE_STRING", "visualbasic", semantic_code };
State VISUALBASIC_LINE_COMMENT = { "VISUALBASIC_LINE_COMMENT", "visualbasic", semantic_comment };
State VISUALBASIC_BLOCK_COMMENT = { "VISUALBASIC_BLOCK_COMMENT", "visualbasic", semantic_comment };
State *VISUALBASIC_STATES[] = { &VISUALBASIC_CODE, &VISUALBASIC_DQUOTE_STRING, &VISUALBASIC_SQUOTE_STRING, &VISUALBASIC_LINE_COMMENT, &VISUALBASIC_BLOCK_COMMENT, NULL };
/* Transitions */
Transition VISUALBASIC_CODE__LINE_COMMENT_0 = { "'", &VISUALBASIC_CODE, &VISUALBASIC_LINE_COMMENT, ToEatsToken, false };
Transition VISUALBASIC_LINE_COMMENT__RETURN = { "\n", &VISUALBASIC_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition VISUALBASIC_CODE__DQUOTE_STRING = { "\"", &VISUALBASIC_CODE, &VISUALBASIC_DQUOTE_STRING, ToEatsToken, false };
Transition VISUALBASIC_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &VISUALBASIC_DQUOTE_STRING, &VISUALBASIC_DQUOTE_STRING, ToEatsToken, true };
Transition VISUALBASIC_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &VISUALBASIC_DQUOTE_STRING, &VISUALBASIC_DQUOTE_STRING, ToEatsToken, true };
Transition VISUALBASIC_DQUOTE_STRING__RETURN = { "\"", &VISUALBASIC_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *VISUALBASIC_TRANSITIONS[] = { &VISUALBASIC_CODE__LINE_COMMENT_0, &VISUALBASIC_LINE_COMMENT__RETURN, &VISUALBASIC_CODE__DQUOTE_STRING, &VISUALBASIC_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &VISUALBASIC_DQUOTE_STRING__DQUOTE_STRING_ESC, &VISUALBASIC_DQUOTE_STRING__RETURN, NULL};
Polyglot VISUALBASIC_POLYGLOT = {
	"visualbasic",
			VISUALBASIC_STATES,
			VISUALBASIC_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      xml
*****************************************************************************/
/* States */
State XML_MARKUP = { "XML_MARKUP", "xml", semantic_code };
State XML_SQUOTE = { "XML_SQUOTE", "xml", semantic_code };
State XML_DQUOTE = { "XML_DQUOTE", "xml", semantic_code };
State XML_CDATA = { "XML_CDATA", "xml", semantic_code };
State XML_COMMENT = { "XML_COMMENT", "xml", semantic_comment };
State *XML_STATES[] = { &XML_MARKUP, &XML_SQUOTE, &XML_DQUOTE, &XML_CDATA, &XML_COMMENT, NULL };
/* Transitions */
Transition XML_MARKUP__SQUOTE = { "'", &XML_MARKUP, &XML_SQUOTE, FromEatsToken, false };
Transition XML_SQUOTE__RETURN = { "'", &XML_SQUOTE, RETURN, ToEatsToken, false };
Transition XML_MARKUP__DQUOTE = { "\"", &XML_MARKUP, &XML_DQUOTE, FromEatsToken, false };
Transition XML_DQUOTE__RETURN = { "\"", &XML_DQUOTE, RETURN, ToEatsToken, false };
Transition XML_MARKUP__CDATA = { "<!\\[CDATA\\[", &XML_MARKUP, &XML_CDATA, FromEatsToken, false };
Transition XML_CDATA__RETURN = { "\\]\\]>", &XML_CDATA, RETURN, ToEatsToken, false };
Transition XML_MARKUP__COMMENT = { "<!--", &XML_MARKUP, &XML_COMMENT, ToEatsToken, false };
Transition XML_COMMENT__RETURN = { "-->", &XML_COMMENT, RETURN, FromEatsToken, false };
Transition *XML_TRANSITIONS[] = { &XML_MARKUP__SQUOTE, &XML_SQUOTE__RETURN, &XML_MARKUP__DQUOTE, &XML_DQUOTE__RETURN, &XML_MARKUP__CDATA, &XML_CDATA__RETURN, &XML_MARKUP__COMMENT, &XML_COMMENT__RETURN, NULL};
Polyglot XML_POLYGLOT = {
	"xml",
			XML_STATES,
			XML_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      dmd
*****************************************************************************/
/* States */
State DMD_CODE = { "DMD_CODE", "dmd", semantic_code };
State DMD_DQUOTE_STRING = { "DMD_DQUOTE_STRING", "dmd", semantic_code };
State DMD_SQUOTE_STRING = { "DMD_SQUOTE_STRING", "dmd", semantic_code };
State DMD_BACKTICK_STRING = { "DMD_BACKTICK_STRING", "dmd", semantic_code };
State DMD_LINE_COMMENT = { "DMD_LINE_COMMENT", "dmd", semantic_comment };
State DMD_BLOCK_COMMENT = { "DMD_BLOCK_COMMENT", "dmd", semantic_comment };
State DMD_NESTED_COMMENT = { "DMD_NESTED_COMMENT", "dmd", semantic_comment };
State *DMD_STATES[] = { &DMD_CODE, &DMD_DQUOTE_STRING, &DMD_SQUOTE_STRING, &DMD_BACKTICK_STRING, &DMD_LINE_COMMENT, &DMD_BLOCK_COMMENT, &DMD_NESTED_COMMENT, NULL };
/* Transitions */
Transition DMD_CODE__LINE_COMMENT = { "//", &DMD_CODE, &DMD_LINE_COMMENT, ToEatsToken, false };
Transition DMD_LINE_COMMENT__RETURN = { "\n", &DMD_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition DMD_CODE__BLOCK_COMMENT = { "/\\*", &DMD_CODE, &DMD_BLOCK_COMMENT, ToEatsToken, false };
Transition DMD_NESTED_COMMENT__BLOCK_COMMENT = { "/\\*", &DMD_NESTED_COMMENT, &DMD_BLOCK_COMMENT, ToEatsToken, false };
Transition DMD_BLOCK_COMMENT__RETURN = { "\\*/", &DMD_BLOCK_COMMENT, RETURN, FromEatsToken, false };
Transition DMD_CODE__NESTED_COMMENT = { "/\\+", &DMD_CODE, &DMD_NESTED_COMMENT, ToEatsToken, false };
Transition DMD_NESTED_COMMENT__NESTED_COMMENT = { "/\\+", &DMD_NESTED_COMMENT, &DMD_NESTED_COMMENT, ToEatsToken, false };
Transition DMD_NESTED_COMMENT__RETURN = { "\\+/", &DMD_NESTED_COMMENT, RETURN, FromEatsToken, false };
Transition DMD_CODE__SQUOTE_STRING = { "'", &DMD_CODE, &DMD_SQUOTE_STRING, ToEatsToken, false };
Transition DMD_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &DMD_SQUOTE_STRING, &DMD_SQUOTE_STRING, FromEatsToken, true };
Transition DMD_SQUOTE_STRING__SQUOTE_STRING_ESC = { "\\\\'", &DMD_SQUOTE_STRING, &DMD_SQUOTE_STRING, FromEatsToken, true };
Transition DMD_SQUOTE_STRING__RETURN = { "'", &DMD_SQUOTE_STRING, RETURN, FromEatsToken, false };
Transition DMD_CODE__BACKTICK_STRING = { "`", &DMD_CODE, &DMD_BACKTICK_STRING, ToEatsToken, false };
Transition DMD_BACKTICK_STRING__BACKTICK_STRING_ESC_SLASH = { "\\\\\\\\", &DMD_BACKTICK_STRING, &DMD_BACKTICK_STRING, FromEatsToken, true };
Transition DMD_BACKTICK_STRING__BACKTICK_STRING_ESC = { "\\\\`", &DMD_BACKTICK_STRING, &DMD_BACKTICK_STRING, FromEatsToken, true };
Transition DMD_BACKTICK_STRING__RETURN = { "`", &DMD_BACKTICK_STRING, RETURN, FromEatsToken, false };
Transition DMD_CODE__DQUOTE_STRING = { "\"", &DMD_CODE, &DMD_DQUOTE_STRING, ToEatsToken, false };
Transition DMD_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH = { "\\\\\\\\", &DMD_DQUOTE_STRING, &DMD_DQUOTE_STRING, ToEatsToken, true };
Transition DMD_DQUOTE_STRING__DQUOTE_STRING_ESC = { "\\\\\"", &DMD_DQUOTE_STRING, &DMD_DQUOTE_STRING, ToEatsToken, true };
Transition DMD_DQUOTE_STRING__RETURN = { "\"", &DMD_DQUOTE_STRING, RETURN, FromEatsToken, false };
Transition *DMD_TRANSITIONS[] = { &DMD_CODE__LINE_COMMENT, &DMD_LINE_COMMENT__RETURN, &DMD_CODE__BLOCK_COMMENT, &DMD_NESTED_COMMENT__BLOCK_COMMENT, &DMD_BLOCK_COMMENT__RETURN, &DMD_CODE__NESTED_COMMENT, &DMD_NESTED_COMMENT__NESTED_COMMENT, &DMD_NESTED_COMMENT__RETURN, &DMD_CODE__SQUOTE_STRING, &DMD_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &DMD_SQUOTE_STRING__SQUOTE_STRING_ESC, &DMD_SQUOTE_STRING__RETURN, &DMD_CODE__BACKTICK_STRING, &DMD_BACKTICK_STRING__BACKTICK_STRING_ESC_SLASH, &DMD_BACKTICK_STRING__BACKTICK_STRING_ESC, &DMD_BACKTICK_STRING__RETURN, &DMD_CODE__DQUOTE_STRING, &DMD_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &DMD_DQUOTE_STRING__DQUOTE_STRING_ESC, &DMD_DQUOTE_STRING__RETURN, NULL};
Polyglot DMD_POLYGLOT = {
	"dmd",
			DMD_STATES,
			DMD_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      html
*****************************************************************************/
/* States */
State HTML_MARKUP = { "HTML_MARKUP", "html", semantic_code };
State HTML_SQUOTE = { "HTML_SQUOTE", "html", semantic_code };
State HTML_DQUOTE = { "HTML_DQUOTE", "html", semantic_code };
State HTML_CDATA = { "HTML_CDATA", "html", semantic_code };
State HTML_COMMENT = { "HTML_COMMENT", "html", semantic_comment };
State *HTML_STATES[] = { &HTML_MARKUP, &HTML_SQUOTE, &HTML_DQUOTE, &HTML_CDATA, &HTML_COMMENT, &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_LINE_COMMENT, &JAVASCRIPT_BLOCK_COMMENT, &CSS_CODE, &CSS_DQUOTE_STRING, &CSS_SQUOTE_STRING, &CSS_LINE_COMMENT, &CSS_BLOCK_COMMENT, NULL };
/* Transitions */
Transition HTML_MARKUP__SQUOTE = { "'", &HTML_MARKUP, &HTML_SQUOTE, FromEatsToken, false };
Transition HTML_SQUOTE__RETURN = { "'", &HTML_SQUOTE, RETURN, ToEatsToken, false };
Transition HTML_MARKUP__DQUOTE = { "\"", &HTML_MARKUP, &HTML_DQUOTE, FromEatsToken, false };
Transition HTML_DQUOTE__RETURN = { "\"", &HTML_DQUOTE, RETURN, ToEatsToken, false };
Transition HTML_MARKUP__CDATA = { "<!\\[CDATA\\[", &HTML_MARKUP, &HTML_CDATA, FromEatsToken, false };
Transition HTML_CDATA__RETURN = { "\\]\\]>", &HTML_CDATA, RETURN, ToEatsToken, false };
Transition HTML_MARKUP__COMMENT = { "<!--", &HTML_MARKUP, &HTML_COMMENT, ToEatsToken, false };
Transition HTML_COMMENT__RETURN = { "-->", &HTML_COMMENT, RETURN, FromEatsToken, false };
Transition HTML_HTML_MARKUP__CSS_CODE = { "<(?i)style(?-i)[^>]*(?i)css(?-i)[^>]*>", &HTML_MARKUP, &CSS_CODE, FromEatsToken, false };
Transition HTML_CSS_CODE__RETURN = { "</(?i)style(?-i)>", &CSS_CODE, RETURN, ToEatsToken, false };
Transition HTML_HTML_MARKUP__JAVASCRIPT_CODE = { "<(?i)script(?-i)\\ [^>]*(?i)javascript(?-i)[^>]*>", &HTML_MARKUP, &JAVASCRIPT_CODE, FromEatsToken, false };
Transition HTML_JAVASCRIPT_CODE__RETURN = { "</(?i)script(?-i)>", &JAVASCRIPT_CODE, RETURN, ToEatsToken, false };
Transition *HTML_TRANSITIONS[] = { &HTML_MARKUP__SQUOTE, &HTML_SQUOTE__RETURN, &HTML_MARKUP__DQUOTE, &HTML_DQUOTE__RETURN, &HTML_MARKUP__CDATA, &HTML_CDATA__RETURN, &HTML_MARKUP__COMMENT, &HTML_COMMENT__RETURN, &HTML_HTML_MARKUP__CSS_CODE, &HTML_CSS_CODE__RETURN, &HTML_HTML_MARKUP__JAVASCRIPT_CODE, &HTML_JAVASCRIPT_CODE__RETURN, &JAVASCRIPT_CODE__LINE_COMMENT_0, &JAVASCRIPT_LINE_COMMENT__RETURN, &JAVASCRIPT_CODE__BLOCK_COMMENT_0, &JAVASCRIPT_BLOCK_COMMENT__RETURN_0, &JAVASCRIPT_CODE__SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC, &JAVASCRIPT_SQUOTE_STRING__RETURN, &JAVASCRIPT_CODE__DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVASCRIPT_DQUOTE_STRING__RETURN, &CSS_CODE__BLOCK_COMMENT_0, &CSS_BLOCK_COMMENT__RETURN_0, NULL};
Polyglot HTML_POLYGLOT = {
	"html",
			HTML_STATES,
			HTML_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      php
*****************************************************************************/
/* States */
State *PHP_STATES[] = { &HTML_MARKUP, &HTML_SQUOTE, &HTML_DQUOTE, &HTML_CDATA, &HTML_COMMENT, &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_LINE_COMMENT, &JAVASCRIPT_BLOCK_COMMENT, &CSS_CODE, &CSS_DQUOTE_STRING, &CSS_SQUOTE_STRING, &CSS_LINE_COMMENT, &CSS_BLOCK_COMMENT, &PHP_CODE, &PHP_DQUOTE_STRING, &PHP_SQUOTE_STRING, &PHP_LINE_COMMENT, &PHP_BLOCK_COMMENT, NULL };
/* Transitions */
Transition PHP_HTML_MARKUP__PHP_CODE = { "<\\?", &HTML_MARKUP, &PHP_CODE, ToEatsToken, false };
Transition PHP_HTML_COMMENT__PHP_CODE = { "<\\?", &HTML_COMMENT, &PHP_CODE, ToEatsToken, false };
Transition PHP_HTML_SQUOTE__PHP_CODE = { "<\\?", &HTML_SQUOTE, &PHP_CODE, ToEatsToken, false };
Transition PHP_HTML_DQUOTE__PHP_CODE = { "<\\?", &HTML_DQUOTE, &PHP_CODE, ToEatsToken, false };
Transition PHP_PHP_CODE__RETURN = { "\\?>", &PHP_CODE, RETURN, FromEatsToken, false };
Transition *PHP_TRANSITIONS[] = { &PHP_HTML_MARKUP__PHP_CODE, &PHP_HTML_COMMENT__PHP_CODE, &PHP_HTML_SQUOTE__PHP_CODE, &PHP_HTML_DQUOTE__PHP_CODE, &PHP_PHP_CODE__RETURN, &HTML_MARKUP__SQUOTE, &HTML_SQUOTE__RETURN, &HTML_MARKUP__DQUOTE, &HTML_DQUOTE__RETURN, &HTML_MARKUP__CDATA, &HTML_CDATA__RETURN, &HTML_MARKUP__COMMENT, &HTML_COMMENT__RETURN, &HTML_HTML_MARKUP__CSS_CODE, &HTML_CSS_CODE__RETURN, &HTML_HTML_MARKUP__JAVASCRIPT_CODE, &HTML_JAVASCRIPT_CODE__RETURN, &JAVASCRIPT_CODE__LINE_COMMENT_0, &JAVASCRIPT_LINE_COMMENT__RETURN, &JAVASCRIPT_CODE__BLOCK_COMMENT_0, &JAVASCRIPT_BLOCK_COMMENT__RETURN_0, &JAVASCRIPT_CODE__SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC, &JAVASCRIPT_SQUOTE_STRING__RETURN, &JAVASCRIPT_CODE__DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVASCRIPT_DQUOTE_STRING__RETURN, &CSS_CODE__BLOCK_COMMENT_0, &CSS_BLOCK_COMMENT__RETURN_0, &PHP_CODE__LINE_COMMENT_0, &PHP_LINE_COMMENT__RETURN, &PHP_CODE__BLOCK_COMMENT_0, &PHP_BLOCK_COMMENT__RETURN_0, &PHP_CODE__SQUOTE_STRING, &PHP_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &PHP_SQUOTE_STRING__SQUOTE_STRING_ESC, &PHP_SQUOTE_STRING__RETURN, &PHP_CODE__DQUOTE_STRING, &PHP_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &PHP_DQUOTE_STRING__DQUOTE_STRING_ESC, &PHP_DQUOTE_STRING__RETURN, NULL};
Polyglot PHP_POLYGLOT = {
	"php",
			PHP_STATES,
			PHP_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                     rhtml
*****************************************************************************/
/* States */
State *RHTML_STATES[] = { &HTML_MARKUP, &HTML_SQUOTE, &HTML_DQUOTE, &HTML_CDATA, &HTML_COMMENT, &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_LINE_COMMENT, &JAVASCRIPT_BLOCK_COMMENT, &CSS_CODE, &CSS_DQUOTE_STRING, &CSS_SQUOTE_STRING, &CSS_LINE_COMMENT, &CSS_BLOCK_COMMENT, &RUBY_CODE, &RUBY_DQUOTE_STRING, &RUBY_SQUOTE_STRING, &RUBY_LINE_COMMENT, &RUBY_BLOCK_COMMENT, NULL };
/* Transitions */
Transition RHTML_HTML_MARKUP__RUBY_CODE = { "<%", &HTML_MARKUP, &RUBY_CODE, FromEatsToken, false };
Transition RHTML_HTML_COMMENT__RUBY_CODE = { "<%", &HTML_COMMENT, &RUBY_CODE, FromEatsToken, false };
Transition RHTML_HTML_SQUOTE__RUBY_CODE = { "<%", &HTML_SQUOTE, &RUBY_CODE, FromEatsToken, false };
Transition RHTML_HTML_DQUOTE__RUBY_CODE = { "<%", &HTML_DQUOTE, &RUBY_CODE, FromEatsToken, false };
Transition RHTML_RUBY_CODE__RETURN = { "%>", &RUBY_CODE, RETURN, ToEatsToken, false };
Transition *RHTML_TRANSITIONS[] = { &RHTML_HTML_MARKUP__RUBY_CODE, &RHTML_HTML_COMMENT__RUBY_CODE, &RHTML_HTML_SQUOTE__RUBY_CODE, &RHTML_HTML_DQUOTE__RUBY_CODE, &RHTML_RUBY_CODE__RETURN, &HTML_MARKUP__SQUOTE, &HTML_SQUOTE__RETURN, &HTML_MARKUP__DQUOTE, &HTML_DQUOTE__RETURN, &HTML_MARKUP__CDATA, &HTML_CDATA__RETURN, &HTML_MARKUP__COMMENT, &HTML_COMMENT__RETURN, &HTML_HTML_MARKUP__CSS_CODE, &HTML_CSS_CODE__RETURN, &HTML_HTML_MARKUP__JAVASCRIPT_CODE, &HTML_JAVASCRIPT_CODE__RETURN, &JAVASCRIPT_CODE__LINE_COMMENT_0, &JAVASCRIPT_LINE_COMMENT__RETURN, &JAVASCRIPT_CODE__BLOCK_COMMENT_0, &JAVASCRIPT_BLOCK_COMMENT__RETURN_0, &JAVASCRIPT_CODE__SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC, &JAVASCRIPT_SQUOTE_STRING__RETURN, &JAVASCRIPT_CODE__DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVASCRIPT_DQUOTE_STRING__RETURN, &CSS_CODE__BLOCK_COMMENT_0, &CSS_BLOCK_COMMENT__RETURN_0, &RUBY_CODE__LINE_COMMENT_0, &RUBY_LINE_COMMENT__RETURN, &RUBY_CODE__SQUOTE_STRING, &RUBY_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &RUBY_SQUOTE_STRING__SQUOTE_STRING_ESC, &RUBY_SQUOTE_STRING__RETURN, &RUBY_CODE__DQUOTE_STRING, &RUBY_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &RUBY_DQUOTE_STRING__DQUOTE_STRING_ESC, &RUBY_DQUOTE_STRING__RETURN, NULL};
Polyglot RHTML_POLYGLOT = {
	"rhtml",
			RHTML_STATES,
			RHTML_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      jsp
*****************************************************************************/
/* States */
State *JSP_STATES[] = { &HTML_MARKUP, &HTML_SQUOTE, &HTML_DQUOTE, &HTML_CDATA, &HTML_COMMENT, &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_LINE_COMMENT, &JAVASCRIPT_BLOCK_COMMENT, &CSS_CODE, &CSS_DQUOTE_STRING, &CSS_SQUOTE_STRING, &CSS_LINE_COMMENT, &CSS_BLOCK_COMMENT, &JAVA_CODE, &JAVA_DQUOTE_STRING, &JAVA_SQUOTE_STRING, &JAVA_LINE_COMMENT, &JAVA_BLOCK_COMMENT, NULL };
/* Transitions */
Transition JSP_HTML_MARKUP__JAVA_CODE = { "<%", &HTML_MARKUP, &JAVA_CODE, FromEatsToken, false };
Transition JSP_HTML_COMMENT__JAVA_CODE = { "<%", &HTML_COMMENT, &JAVA_CODE, FromEatsToken, false };
Transition JSP_HTML_SQUOTE__JAVA_CODE = { "<%", &HTML_SQUOTE, &JAVA_CODE, FromEatsToken, false };
Transition JSP_HTML_DQUOTE__JAVA_CODE = { "<%", &HTML_DQUOTE, &JAVA_CODE, FromEatsToken, false };
Transition JSP_JAVA_CODE__RETURN = { "%>", &JAVA_CODE, RETURN, ToEatsToken, false };
Transition *JSP_TRANSITIONS[] = { &JSP_HTML_MARKUP__JAVA_CODE, &JSP_HTML_COMMENT__JAVA_CODE, &JSP_HTML_SQUOTE__JAVA_CODE, &JSP_HTML_DQUOTE__JAVA_CODE, &JSP_JAVA_CODE__RETURN, &HTML_MARKUP__SQUOTE, &HTML_SQUOTE__RETURN, &HTML_MARKUP__DQUOTE, &HTML_DQUOTE__RETURN, &HTML_MARKUP__CDATA, &HTML_CDATA__RETURN, &HTML_MARKUP__COMMENT, &HTML_COMMENT__RETURN, &HTML_HTML_MARKUP__CSS_CODE, &HTML_CSS_CODE__RETURN, &HTML_HTML_MARKUP__JAVASCRIPT_CODE, &HTML_JAVASCRIPT_CODE__RETURN, &JAVASCRIPT_CODE__LINE_COMMENT_0, &JAVASCRIPT_LINE_COMMENT__RETURN, &JAVASCRIPT_CODE__BLOCK_COMMENT_0, &JAVASCRIPT_BLOCK_COMMENT__RETURN_0, &JAVASCRIPT_CODE__SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC, &JAVASCRIPT_SQUOTE_STRING__RETURN, &JAVASCRIPT_CODE__DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVASCRIPT_DQUOTE_STRING__RETURN, &CSS_CODE__BLOCK_COMMENT_0, &CSS_BLOCK_COMMENT__RETURN_0, &JAVA_CODE__LINE_COMMENT_0, &JAVA_LINE_COMMENT__RETURN, &JAVA_CODE__BLOCK_COMMENT_0, &JAVA_BLOCK_COMMENT__RETURN_0, &JAVA_CODE__DQUOTE_STRING, &JAVA_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVA_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVA_DQUOTE_STRING__RETURN, NULL};
Polyglot JSP_POLYGLOT = {
	"jsp",
			JSP_STATES,
			JSP_TRANSITIONS,
	NULL
};

/*****************************************************************************
                              clearsilver_template
*****************************************************************************/
/* States */
State *CLEARSILVER_TEMPLATE_STATES[] = { &HTML_MARKUP, &HTML_SQUOTE, &HTML_DQUOTE, &HTML_CDATA, &HTML_COMMENT, &JAVASCRIPT_CODE, &JAVASCRIPT_DQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING, &JAVASCRIPT_LINE_COMMENT, &JAVASCRIPT_BLOCK_COMMENT, &CSS_CODE, &CSS_DQUOTE_STRING, &CSS_SQUOTE_STRING, &CSS_LINE_COMMENT, &CSS_BLOCK_COMMENT, &CLEARSILVER_CODE, &CLEARSILVER_DQUOTE_STRING, &CLEARSILVER_SQUOTE_STRING, &CLEARSILVER_LINE_COMMENT, &CLEARSILVER_BLOCK_COMMENT, NULL };
/* Transitions */
Transition CLEARSILVER_TEMPLATE_HTML_MARKUP__CLEARSILVER_CODE = { "<\\?cs", &HTML_MARKUP, &CLEARSILVER_CODE, FromEatsToken, false };
Transition CLEARSILVER_TEMPLATE_HTML_COMMENT__CLEARSILVER_CODE = { "<\\?cs", &HTML_COMMENT, &CLEARSILVER_CODE, FromEatsToken, false };
Transition CLEARSILVER_TEMPLATE_HTML_SQUOTE__CLEARSILVER_CODE = { "<\\?cs", &HTML_SQUOTE, &CLEARSILVER_CODE, FromEatsToken, false };
Transition CLEARSILVER_TEMPLATE_HTML_DQUOTE__CLEARSILVER_CODE = { "<\\?cs", &HTML_DQUOTE, &CLEARSILVER_CODE, FromEatsToken, false };
Transition CLEARSILVER_TEMPLATE_CLEARSILVER_CODE__RETURN = { "\\?>", &CLEARSILVER_CODE, RETURN, ToEatsToken, false };
Transition *CLEARSILVER_TEMPLATE_TRANSITIONS[] = { &CLEARSILVER_TEMPLATE_HTML_MARKUP__CLEARSILVER_CODE, &CLEARSILVER_TEMPLATE_HTML_COMMENT__CLEARSILVER_CODE, &CLEARSILVER_TEMPLATE_HTML_SQUOTE__CLEARSILVER_CODE, &CLEARSILVER_TEMPLATE_HTML_DQUOTE__CLEARSILVER_CODE, &CLEARSILVER_TEMPLATE_CLEARSILVER_CODE__RETURN, &HTML_MARKUP__SQUOTE, &HTML_SQUOTE__RETURN, &HTML_MARKUP__DQUOTE, &HTML_DQUOTE__RETURN, &HTML_MARKUP__CDATA, &HTML_CDATA__RETURN, &HTML_MARKUP__COMMENT, &HTML_COMMENT__RETURN, &HTML_HTML_MARKUP__CSS_CODE, &HTML_CSS_CODE__RETURN, &HTML_HTML_MARKUP__JAVASCRIPT_CODE, &HTML_JAVASCRIPT_CODE__RETURN, &JAVASCRIPT_CODE__LINE_COMMENT_0, &JAVASCRIPT_LINE_COMMENT__RETURN, &JAVASCRIPT_CODE__BLOCK_COMMENT_0, &JAVASCRIPT_BLOCK_COMMENT__RETURN_0, &JAVASCRIPT_CODE__SQUOTE_STRING, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_SQUOTE_STRING__SQUOTE_STRING_ESC, &JAVASCRIPT_SQUOTE_STRING__RETURN, &JAVASCRIPT_CODE__DQUOTE_STRING, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &JAVASCRIPT_DQUOTE_STRING__DQUOTE_STRING_ESC, &JAVASCRIPT_DQUOTE_STRING__RETURN, &CSS_CODE__BLOCK_COMMENT_0, &CSS_BLOCK_COMMENT__RETURN_0, &CLEARSILVER_CODE__LINE_COMMENT_0, &CLEARSILVER_LINE_COMMENT__RETURN, &CLEARSILVER_CODE__SQUOTE_STRING, &CLEARSILVER_SQUOTE_STRING__SQUOTE_STRING_ESC_SLASH, &CLEARSILVER_SQUOTE_STRING__SQUOTE_STRING_ESC, &CLEARSILVER_SQUOTE_STRING__RETURN, &CLEARSILVER_CODE__DQUOTE_STRING, &CLEARSILVER_DQUOTE_STRING__DQUOTE_STRING_ESC_SLASH, &CLEARSILVER_DQUOTE_STRING__DQUOTE_STRING_ESC, &CLEARSILVER_DQUOTE_STRING__RETURN, NULL};
Polyglot CLEARSILVER_TEMPLATE_POLYGLOT = {
	"clearsilver_template",
			CLEARSILVER_TEMPLATE_STATES,
			CLEARSILVER_TEMPLATE_TRANSITIONS,
	NULL
};

/*****************************************************************************
                                      tex
*****************************************************************************/
/* States */
State TEX_CODE = { "TEX_CODE", "tex", semantic_code };
State TEX_DQUOTE_STRING = { "TEX_DQUOTE_STRING", "tex", semantic_code };
State TEX_SQUOTE_STRING = { "TEX_SQUOTE_STRING", "tex", semantic_code };
State TEX_LINE_COMMENT = { "TEX_LINE_COMMENT", "tex", semantic_comment };
State TEX_BLOCK_COMMENT = { "TEX_BLOCK_COMMENT", "tex", semantic_comment };
State *TEX_STATES[] = { &TEX_CODE, &TEX_DQUOTE_STRING, &TEX_SQUOTE_STRING, &TEX_LINE_COMMENT, &TEX_BLOCK_COMMENT, NULL };
/* Transitions */
Transition TEX_CODE__LINE_COMMENT_0 = { "%", &TEX_CODE, &TEX_LINE_COMMENT, ToEatsToken, false };
Transition TEX_LINE_COMMENT__RETURN = { "\n", &TEX_LINE_COMMENT, RETURN, FromEatsToken, false };
Transition *TEX_TRANSITIONS[] = { &TEX_CODE__LINE_COMMENT_0, &TEX_LINE_COMMENT__RETURN, NULL};
Polyglot TEX_POLYGLOT = {
	"tex",
			TEX_STATES,
			TEX_TRANSITIONS,
	NULL
};


/*****************************************************************************
                                   POLYGLOTS
*****************************************************************************/
Polyglot *POLYGLOTS[] = {
	&ADA_POLYGLOT,
	&ASSEMBLER_POLYGLOT,
	&AWK_POLYGLOT,
	&BAT_POLYGLOT,
	&BOO_POLYGLOT,
	&CLEARSILVER_POLYGLOT,
	&CNCPP_POLYGLOT,
	&CSHARP_POLYGLOT,
	&CSS_POLYGLOT,
	&DYLAN_POLYGLOT,
	&ERLANG_POLYGLOT,
	&GROOVY_POLYGLOT,
	&JAVA_POLYGLOT,
	&JAVASCRIPT_POLYGLOT,
	&EMACSLISP_POLYGLOT,
	&HASKELL_POLYGLOT,
	&LISP_POLYGLOT,
	&LUA_POLYGLOT,
	&MATLAB_POLYGLOT,
	&OBJECTIVE_C_POLYGLOT,
	&PASCAL_POLYGLOT,
	&PERL_POLYGLOT,
	&PHPLANGUAGE_POLYGLOT,
	&PYTHON_POLYGLOT,
	&RUBY_POLYGLOT,
	&REXX_POLYGLOT,
	&SCHEME_POLYGLOT,
	&SHELL_POLYGLOT,
	&SQL_POLYGLOT,
	&TCL_POLYGLOT,
	&VALA_POLYGLOT,
	&VISUALBASIC_POLYGLOT,
	&XML_POLYGLOT,
	&DMD_POLYGLOT,
	&HTML_POLYGLOT,
	&PHP_POLYGLOT,
	&RHTML_POLYGLOT,
	&JSP_POLYGLOT,
	&CLEARSILVER_TEMPLATE_POLYGLOT,
	&TEX_POLYGLOT,
	NULL
};
