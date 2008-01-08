/*
 *  state.c
 *  Ohcount
 *
 *  Created by Jason Allen on 6/22/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */
#include "common.h"

/*
 void state_initialize(State *state, char *name, enum Semantic semantic) {
	state->name = name;
	state->semantic = semantic;
}
*/
/*
 * test suite
 *
 * performs an overall test suite on State.
 *
 */
void state_test(void) {
	printf("passed state_test.\n");
}

bool state_trumps_language(State *the_state, State *other_state) {
	if (the_state == NULL ||
			the_state->semantic == semantic_blank ||
			the_state->semantic == semantic_null ||
			other_state == NULL) {
		return false;
	}
	// simple algorithm... html gets trumped by everything
	bool trumped = (strcmp(other_state->language, "html") == 0 && strcmp(the_state->language, "html") != 0);
#ifndef NDEBUG
	if (trumped) {
		log2("[ohcount] - state %s trumped by %s\n", other_state->name, the_state->name);
	}
#endif
	return trumped;
}
