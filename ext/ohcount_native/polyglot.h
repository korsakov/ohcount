/*
 *  polyglot.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/23/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

typedef struct {
	char *name;
	State **states;
	Transition **transitions;
	CompiledState *compiled_states;
	int compiled_state_count;
} Polyglot;

int polyglot_state_count(Polyglot *polyglot);
void polyglot_compile_states(Polyglot *polyglot);
