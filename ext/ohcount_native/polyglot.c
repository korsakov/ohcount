/*
 *  polyglot.c
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */
#include "common.h"


/*
 * polyglot_state_count
 *
 * Returns the number of states a polyglot contains
 *
 */
int polyglot_state_count(Polyglot *polyglot) {
	int count = 0;
	for ( ; polyglot->states[count] != NULL; count++) {}
	return count;
}

/*
 * polyglot_compile_states
 *
 * creates an associated CompiledState for every State
 * contained in a polyglot. CompiledStates are used by
 * the parser to avoid doing expensive lookups and avoid
 * redundant processing.
 *
 */
void polyglot_compile_states(Polyglot *polyglot) {
	if (polyglot->compiled_states == NULL) {
		// compile them!
		int state_count = polyglot_state_count(polyglot);
		polyglot->compiled_states = malloc(sizeof(CompiledState) * state_count);
		polyglot->compiled_state_count = state_count;
		int i = 0;
		for (; i < state_count; i++) {
			compiled_state_initialize(&polyglot->compiled_states[i], polyglot->states[i], polyglot->transitions);
		}
	}
}
