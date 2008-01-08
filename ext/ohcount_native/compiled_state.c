/*
 *  compiled_state.c
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

#include "common.h"


Transition *compiled_state_get_transition(CompiledState *compiled_state, int nth_transition) {
	return compiled_state->transition_map[nth_transition];
}

/*
 * compiled_state_initialize
 *
 * a 'compiled_state' helps the parser walk the DFA faster by precomputing the regular expression
 * for each state. Basically any transition __from__ a state is added to the regex term. We also
 * ensure the "\n" transition (to force end-of-line processing).
 *
 */
void compiled_state_initialize(CompiledState *compiled_state, State *state, Transition *transitions[]) {
	compiled_state->state = state;

	Transition **pp_t_cur = transitions;
	Transition **pp_t_map = compiled_state->transition_map;
	char *regex_cur = compiled_state->regex;
	bool seen_newline = false;

	for (; (*pp_t_cur) != NULL; pp_t_cur++) {
		Transition *t_cur = *pp_t_cur;
		if (t_cur->from_state == state) {

			// hey! this is us! add this transition to our regex
			*regex_cur++ = '(';
			if (!seen_newline) {
				seen_newline = *t_cur->regex == '\n';
			}
			char *regex_src = t_cur->regex;
			while ((*regex_cur++ = *regex_src++)) {}
			regex_cur--; // dont want the nil!
			*regex_cur++ = ')';
			*regex_cur++ = '|';

			// add this transition to our map
			(*pp_t_map) = t_cur;
			pp_t_map++;
		}
	}

	// add newline (only if it's not already there...)
	if (!seen_newline) {
		*regex_cur++ = '(';
		*regex_cur++ = '\n';
		*regex_cur++ = ')';
		*regex_cur++ = '|'; // just to stay similar to loop pattern
		(*pp_t_map) = NULL; // make sure we are pointing to a NULL transition
	}

	// terminate the string
	*--regex_cur = 0;

	// some sanity checks
#ifndef NDEBUG
	int transition_count = pp_t_map - compiled_state->transition_map;
	if (transition_count >= MAX_TRANSITIONS) {
		log("[ohcount] - ASSERT FAILED: transition_count > MAX (%d)\n", transition_count);
	}
#endif

	const char *error;
	int erroffset;
	compiled_state->pcre = pcre_compile(compiled_state->regex,          /* the pattern */
																			0,                              /* default options */
																			&error,                         /* for error message */
																			&erroffset,                     /* for error offset */
																			NULL);                          /* use default character tables */

	const char *errptr;
	/* since we're likely going to reuse this often, go ahead and study it */
	/* we dont care about errors - it will return NULL which is fine */
	compiled_state->pcre_extra = pcre_study(compiled_state->pcre,  /* result of pcre_compile() */
																					0,                     /* no options exist */
																					&errptr);                 /* set to NULL or points to a message */
}

