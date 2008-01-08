/*
 *  compiled_state.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

typedef struct {
	State *state;
	char regex[MAX_REGEX];
	pcre *pcre;
	pcre_extra *pcre_extra;
	Transition *transition_map[MAX_TRANSITIONS];
} CompiledState;


Transition *compiled_state_get_transition(CompiledState *compiled_state, int transition_index);
void compiled_state_initialize(CompiledState *compiled_state, State *state, Transition *transitions[]);

