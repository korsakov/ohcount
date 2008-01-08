/*
 *  transition.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/22/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

#ifndef __transition_h__
#define __transition_h__

#include "state.h"

enum TokenEater {
	FromEatsToken,
	ToEatsToken,
	NeitherEatsToken
};

// structs
typedef struct  {

	// the regular expression that triggers this transision
	char *regex;

	// the states this transition maps
	State *from_state;
	State *to_state;

	// which state should get the matched token attributed to it?
	enum TokenEater token_eater;

	// true if this transition should be ignored -- useful to preempt other matches
	bool fake_transition;

} Transition;

#endif
