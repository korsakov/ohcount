/*
 *  parser.c
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

/* #include <mcheck.h> - for memory debugging */
#include "ruby.h"
#include "common.h"


/*****************************************************************************
                                 ParseContext
*****************************************************************************/

/*
 * ParseContext holds all the state required to parse a buffer
 *
 * This is where we keep state of an ongoing parse. It's not in the header file because
 * it's not meant to be shared with anyone else... strictly internal!
 */
typedef struct {
	// the buffer we're parsing
	char *parse_buffer;

	// the length of the entire buffer
	int parse_buffer_len;

	// the current cursor we're processing
	char *parse_cur;

	// the length of the buffer left to parse
	int parse_left_len;

	// where the current line started (just past the last newline)
	char *parse_line_start;

	// where there current state should start attribution from
	char *attribute_from;

	// the index of the current line (just for debugging)
	int cur_line_index;

	// the state stack
	CompiledState *cs_stack[MAX_CS_STACK];
	int cs_stack_index;

	// the state we're attributing this current line to (NULL means we haven't attributed it yet!)
	State *line_attributed_state;

	// language_breakdowns
	LanguageBreakdown language_breakdowns[MAX_LANGUAGE_BREAKDOWN_SIZE];
	int language_breakdown_count;

} ParseContext;

/*
 * parse_context_find_or_create_language_breakdown
 *
 * Will return a valid language_breakdown pointer for a given language name.
 */
LanguageBreakdown *parse_context_find_or_create_language_breakdown(ParseContext *parse_context, char *name) {
	int i_lb;

	// iterate to find
	for (i_lb = 0; i_lb < parse_context->language_breakdown_count; i_lb++) {
		if (strcmp(parse_context->language_breakdowns[i_lb].name, name) == 0) {
			return &parse_context->language_breakdowns[i_lb];
		}
	}

	// doesn't exist, create new onw
	log("[ohcount] creating language_breakdown: '%s'\n", name);
#ifndef NDEBUG
	if (parse_context->language_breakdown_count >= MAX_LANGUAGE_BREAKDOWN_SIZE) {
		log("[ohcount] - ASSERT FAILED: parse_context->language_breakdown_count too big (%d)\n", parse_context->language_breakdown_count);
	}
#endif
	language_breakdown_initialize(&parse_context->language_breakdowns[parse_context->language_breakdown_count], name, parse_context->parse_buffer_len + 5); /* just in case we pad with newline or something */
	log("[ohcount] done creating language_breakdown: '%s'\n", name);
	return &parse_context->language_breakdowns[parse_context->language_breakdown_count++];
}

/*
 * parse_yield_line
 *
 * yeilds the just-processed line back up to an optional Ruby block,
 * along with its language and semantic information.
 */
void parse_yield_line(ParseContext *parse_context, char *up_to, State *state) {
	VALUE ary;
	if (rb_block_given_p()) {
		ary = rb_ary_new2(2);
		rb_ary_store(ary, 0, ID2SYM(rb_intern(state->language)));
		rb_ary_store(ary, 2, rb_str_new(parse_context->parse_line_start, up_to - parse_context->parse_line_start));

		switch (state->semantic) {
			case semantic_code:
				rb_ary_store(ary, 1, ID2SYM(rb_intern("code")));
				break;
			case semantic_comment:
				rb_ary_store(ary, 1, ID2SYM(rb_intern("comment")));
				break;
			case semantic_blank:
			case semantic_null:
				rb_ary_store(ary, 1, ID2SYM(rb_intern("blank")));
				break;
			default:
				break;
		}
		rb_yield(ary);
	}
}

/*
 * parse_context_process_line
 *
 * will 'consume' the current line (parse_context->parse_line_start to 'up_to').
 * code and comments are copied, blanks are simply tallied up.
 */
void parse_context_process_line(ParseContext *parse_context, char *up_to, State *state) {
	parse_yield_line(parse_context, up_to, state);

	LanguageBreakdown *lb = parse_context_find_or_create_language_breakdown(parse_context,state->language);
	switch (state->semantic) {
		case semantic_code:
			language_breakdown_copy_code(lb, parse_context->parse_line_start, up_to);
			break;
		case semantic_comment:
			language_breakdown_copy_comment(lb, parse_context->parse_line_start, up_to);
			break;
		case semantic_null:
		case semantic_blank:
			log("[ohcount] blankline at line %d\n", parse_context->cur_line_index);
			lb->blank_count++;
			break;
		default:
			die("Unknown semantic", ERR_UNKNOWN_SEMANTIC);
	}
}

/*
 * parse_context_current_cs
 *
 * accessor for the top of the CompiledState stack
 */
CompiledState *parse_context_current_cs(ParseContext *parse_context) {
#ifndef NDEBUG
	if (parse_context->cs_stack_index < 0 ||	parse_context->cs_stack_index >= MAX_CS_STACK) {
		log("[ohcount] - ASSERT FAILED: parse_context->cs_stack_index out of bounds (%d)\n", parse_context->cs_stack_index);
	}
#endif
	if (parse_context->cs_stack_index == 0) {
		return NULL;
	}
	return parse_context->cs_stack[parse_context->cs_stack_index - 1];
}

/*
 * parse_context_current_state
 *
 * accessor for state represented by the top of the CompiledState stack
 */
State *parse_context_current_state(ParseContext *parse_context) {
	CompiledState *cs = parse_context_current_cs(parse_context);
	if (cs == NULL) {
		return NULL;
	}
	return cs->state;
}

/*
 * parse_context_last_attributed_semantic
 *
 * accessor that returns the current line's attributed semantic (null if none was attributed
 * yet).
 */
enum Semantic parse_context_last_attributed_semantic(ParseContext *parse_context) {
	if (parse_context->line_attributed_state == NULL) {
		return semantic_null;
	}
	return parse_context->line_attributed_state->semantic;
}

/*
 * parse_context_current_pcre
 *
 * returns the pcre (compiled regular expression) for the current state
 */
pcre *parse_context_current_pcre(ParseContext *parse_context) {
	return parse_context_current_cs(parse_context)->pcre;
}

/*
 * parse_context_current_pcre_extra
 *
 * returns the pcre_extra (compiled regular expression additional hints) for the current state
 */
pcre_extra *parse_context_current_pcre_extra(ParseContext *parse_context) {
	return parse_context_current_cs(parse_context)->pcre_extra;
}

/*
 * parse_context_attribute
 *
 * Determines whether the chunk of code seen up to 'at' should be attributed to the
 * current state or not. The rules are pretty simple:
 *  - semantic_null < semantic_blank < semantic_comment < semantic_code
 *  - comment and code don't count if there are only blanks characters
 *
 * if we ate a newline then we also do some postprocessing -- mostly copy the current
 * line to the appropriate buffer.
 *
 */
void parse_context_attribute(ParseContext *parse_context, char *at, bool process_line) {
	enum Semantic last_semantic = parse_context_last_attributed_semantic(parse_context);
	State *state = parse_context_current_state(parse_context);
	bool trumped = state_trumps_language(state, parse_context->line_attributed_state);

	log0("[ohcount] - __ATTRIBUTION__\n");
#ifndef NDEBUG
	char temp_buf[20];
	int max_chars = (at - parse_context->attribute_from);
	if (max_chars > 19) {
		max_chars = 19;
	}
	strncpy(temp_buf, parse_context->attribute_from, max_chars);
	temp_buf[max_chars] = 0;
	if (state) {
		log2("[ohcount] - state[%s] eating '%s'\n", state->name, temp_buf);
	} else {
		log("[ohcount] - NULL state eating '%s'\n", temp_buf);
	}
	State *last_state = parse_context->line_attributed_state;
	if (last_state) {
		log("[ohcount] - last_attirbuted_state: '%s'\n", last_state->name);
	}
#endif



	// shortcut -- if we've already found code, nothing else could really make a difference -- just bail
	if (last_semantic != semantic_code || trumped) {

		// main code to attribute the chunk of code
		log2("[ohcount] - attributing(at[%d], attribute_from[%d]\n", at, parse_context->attribute_from);
		if (at > parse_context->attribute_from) {

			// if we're attributing to blank, we dont care what's in the string
			if (state->semantic == semantic_blank && last_semantic == semantic_null) {
				parse_context->line_attributed_state = state;
				log2("[ohcount] - line %d now being assigned state '%s'\n", parse_context->cur_line_index, state->name);
			} else {

				// we need to see some non-blank characters before we can acredit a comment or code
				char *cur = parse_context->attribute_from;
				bool saw_non_blank = false;
				while (cur < at) {
					if (*cur > 32) { /* ascii chars below 32 are non-printing */
						log2("attributing character 0x%x %c\n", (int)*cur, *cur);
						saw_non_blank = true;
						cur = at;
					}
					cur++;
				}
				if (saw_non_blank) {
					if (trumped || (
								(last_semantic == semantic_blank || last_semantic == semantic_null) &&
								(state->semantic == semantic_code || state->semantic == semantic_comment) )) {
						parse_context->line_attributed_state = state;
						log2("[ohcount] - line %d now being assigned state '%s'\n", parse_context->cur_line_index, state->name);
					} else if (last_semantic == semantic_comment && state->semantic == semantic_code) {
						parse_context->line_attributed_state = state;
						log2("[ohcount] - line %d now being assigned state '%s'\n", parse_context->cur_line_index, state->name);
					}
				}
			}
		}
	}

	// copy line to appropriate buffer, if appropriate
	if (process_line) {

		State *attributed_state = parse_context->line_attributed_state;
		State temp_state;

		if (attributed_state == NULL) {
			// if the line is totally blank, we haven't attributed it to anything yet
			// instead, we'll invent a temporary state (same language.name as previous state on stack, but semantic blank)
			temp_state.language = parse_context_current_state(parse_context)->language;
			temp_state.name = parse_context_current_state(parse_context)->name;
			temp_state.semantic = semantic_blank;
			attributed_state = &temp_state;
			log("[ohcount] - eating_newline. line_attributed_state=[MADE UP! semantic blank, language->%s\n", attributed_state->language);
		} else {
			log("[ohcount] - eating_newline. line_attributed_state=%s\n", attributed_state->name);
		}

		parse_context_process_line(parse_context, at, attributed_state);
		parse_context->parse_line_start = at;
		parse_context->attribute_from = at;
		parse_context->line_attributed_state = NULL;
		parse_context->cur_line_index++;
	}

}


/*
 * parse_context_transit
 *
 * performs transition to new state (by pushing or popping the compiled_state stack)
 *
 */
void parse_context_transit(ParseContext *parse_context, CompiledState *cs, char *at) {
	// push (or pop)
	if (cs == NULL) {
#ifndef NDEBUG
		if (parse_context->cs_stack_index <= 0) {
			log("[ohcount] - ASSERT FAILED: cs_stack_index underflow (%d)\n", parse_context->cs_stack_index);
		}
#endif
		parse_context->cs_stack[--parse_context->cs_stack_index] = cs;
	} else {
#ifndef NDEBUG
		if (parse_context->cs_stack_index + 1 >= MAX_CS_STACK) {
			log("[ohcount] - ASSERT FAILED: cs_stack_index overflow (%d)\n", parse_context->cs_stack_index);
		}
#endif
		parse_context->cs_stack[parse_context->cs_stack_index++] = cs;
	}
	parse_context->attribute_from = at;

}

/*
 * parse_context_initialize
 *
 * Initialized a parse_context to be ready to start parsing.
 *
 */
void parse_context_initialize(ParseContext *parse_context, char *buffer, int buffer_len, CompiledState *initial_cs_state) {
	parse_context->parse_buffer = buffer;
	parse_context->parse_buffer_len = buffer_len;
	parse_context->parse_cur = buffer;
	parse_context->attribute_from = buffer;
	parse_context->parse_left_len = buffer_len;
	parse_context->parse_line_start = buffer;
	parse_context->cur_line_index = 1; // editors are 1-based...debugging is easier

	parse_context->cs_stack_index = 0;
	parse_context->line_attributed_state = NULL;
	parse_context->language_breakdown_count = 0;

	parse_context_attribute(parse_context, buffer, false);
	parse_context_transit(parse_context, initial_cs_state, buffer);
}


/*
 * parse_context_get_transition
 *
 * returns the "nth" transition from the current parse_context.
 *
 */
Transition *parse_context_get_transition(ParseContext *parse_context, int transition_index) {
	CompiledState *compiled_state = parse_context_current_cs(parse_context);
	return compiled_state_get_transition(compiled_state, transition_index);
}



/*****************************************************************************
                                  ParseResult
*****************************************************************************/

/*
 * parse_result_initialize
 *
 * initializes a parse_result from the parse_context
 *
 */
void parse_result_initialize(ParseResult *pr, ParseContext *parse_context) {
	int i_lb;
	for (i_lb = 0; i_lb < parse_context->language_breakdown_count; i_lb++) {
			pr->language_breakdowns[i_lb] = parse_context->language_breakdowns[i_lb];
	}
	pr->language_breakdown_count = parse_context->language_breakdown_count;
}

/*
 * parse_result_free
 *
 * Deallocates the memory held by a ParseResult.
 *
 */
void parse_result_free(ParseResult *parse_result) {
	int i_lb;
	for (i_lb = 0; i_lb < parse_result->language_breakdown_count; i_lb++) {
		language_breakdown_free(&parse_result->language_breakdowns[i_lb]);
	}
}


/*****************************************************************************
                                     Parser
*****************************************************************************/

/*
 * parser_print_match
 *
 * As a debugging tool, we print out the exact matched string.
 *
 */
void parser_print_match(ParseContext *parse_context, int *ovector, int result) {
	char match[10];
	pcre_copy_substring(parse_context->parse_cur, ovector, result, result - 1, match, 10);
	if (match[0] == '\n') {
		log2("[ohcount] state '%s' matched [%s]\n", parse_context_current_state(parse_context)->name,	"\\n");
	} else {
		log2("[ohcount] state '%s' matched [%s]\n", parse_context_current_state(parse_context)->name,	match);
	}
}

/*
 * parser_ate_newline
 *
 * returns true if the pcre result ate a newline
 *
 */
bool parser_ate_newline(ParseContext *parse_context, int *ovector) {
	char *c = parse_context->parse_cur + ovector[0];
	char *c_last = parse_context->parse_cur + ovector[1];
	while (c < c_last) {
		if (*c++ == '\n') {
			return true;
		}
	}
	return false;
}


/*
 * parser_parse
 *
 * The main parsing algorith consists of doing a DFA walk on the source code.
 * We start in the initial state of the language and then maintain a stack of
 * states. Transitions are triggered as regular expression matches (as defined
 * by each state). At every transition we account for the code seen. We keep
 * track for each line what semantic we've seen so far. Semantics trump each
 * other in the following order: null < blank < comment < code. As soon as we
 * see any code, we pretty much ignore other semantics until the newline. We
 * do, however, keep parsing since we need to maintain the states properly -
 * in other words, jumping to the newline might make us forget to jump out
 * of a string state, or something.
 *
 */
void parser_parse(ParseResult *pr, char *buffer, int buffer_len, Polyglot *polyglot) {
#ifndef NDEBUG
/* to help debug, export MALLOC_TRACE to output file */
/*	mtrace(); */
#endif

	// make sure we have compiled states
	polyglot_compile_states(polyglot);

	// setup the parse context
	ParseContext parse_context;
	parse_context_initialize(&parse_context, buffer, buffer_len, &polyglot->compiled_states[0]);

	// MAIN_PARSE_LOOP
	int ovector[30];
	int result;
	while ((result = pcre_exec(parse_context_current_pcre(&parse_context), NULL, parse_context.parse_cur,  parse_context.parse_left_len, 0, 0, ovector, 30)) >= 0) {

#ifndef NDEBUG
		log("[ohcount] pcre result: %d\n", result);
		parser_print_match(&parse_context, ovector, result);
#endif

		// crappy hack work around to solve surprisingly complex bug
		// its all about the last line - how to avoid attributing twice or not at all
		// The complexity comes about because sometimes we actually account for it
		// "automatically" - like when the file ends with a newline. However, when it doesn't
		//


		// transition if possible (there might not be one if its a newline!)
		Transition *t = parse_context_get_transition(&parse_context, result - 2); // -1 for pcre_exec storing the entire match first, -1 to be zero-based (pcre is 1-based, kinda)

		if (t && t->fake_transition) {
			// fake transition -- just ignore it!
			log0("- fake transition, still in current state");
		} else {
			CompiledState *target_cs = NULL;
			if (t && t->to_state) {
				// find the target compiled_state
				for (target_cs = polyglot->compiled_states; target_cs->state != t->to_state; target_cs++) {}
			}

			// source or target: who eats the matched string itself?
			int at = (t == NULL || t->token_eater == FromEatsToken) ? ovector[1] : ovector[0];

			// attribute the code/text/blanks we've seen so far
			bool ate_newline =  parser_ate_newline(&parse_context, ovector);
			parse_context_attribute(&parse_context, parse_context.parse_cur + at, ate_newline);

			// and transit to our new state (note: we usually won't have a transition if we hit a newline)
			// set the 'at' at the proper place, depending on TokenEater
			at = (t != NULL && (t->token_eater == ToEatsToken)) ? ovector[0] : ovector[1];
			if (t && !t->fake_transition) {
				log("[ohcount] - transition at %d\n", parse_context.parse_cur + at);
				parse_context_transit(&parse_context, target_cs, parse_context.parse_cur + at);
			}

#ifndef NDEBUG
			if (ate_newline) {
			log2("[ohcount] -- starting line %d in state %s\n", parse_context.cur_line_index, parse_context_current_state(&parse_context)->name);
			}
#endif
		}
		// move forward
		int jump_chars = (ovector[0] > ovector[1]) ? ovector[0] : ovector[1];
		parse_context.parse_left_len -= jump_chars ;
		parse_context.parse_cur += jump_chars;
	}

	switch (result) {
		case PCRE_ERROR_NOMATCH:
			// attribute what we (might have) eaten so far...
			if (parse_context.parse_cur[parse_context.parse_left_len - 1] != '\n') {
				parse_context_attribute(&parse_context, parse_context.parse_cur + parse_context.parse_left_len, true);
			}
			break;
		case PCRE_ERROR_NOMEMORY:
			die("PCRE_ERROR_NOMEMORY", ERR_PCRE_OUT_OF_MEMORY);
			break;
		default:
			die("PCRE ERROR", ERR_PCRE_GENERIC);
			break;
	}

	/* setup the parse result */
	parse_result_initialize(pr, &parse_context);

#ifndef NDEBUG
/*	muntrace(); */
#endif
}


/*
 * parser_test
 *
 * internal testing code
 */
void parser_test() {
	char buffer[] = "\"str//i\\\"ng\"";
	ParseResult pr;
	int len = strlen(buffer);
	parser_parse(&pr, buffer, len, POLYGLOTS[0]);
	printf("parsing this buffer:\n%s\n=============\n", buffer);
	printf("__code_start__\n%s\n__code_end__\n", pr.language_breakdowns[0].code);
	printf("__comment_start__\n%s\n__comment_end__\n", pr.language_breakdowns[0].comment);
	printf("blanks[%d]\n", pr.language_breakdowns[0].blank_count);
}
