/*
 *  state.h
 *  Ohcount
 *
 *  Created by Jason Allen on 6/22/06.
 *  Copyright 2006 Ohloh. All rights reserved.
 *
 */

#ifndef __state_h__
#define __state_h__

// required
#include "transition.h"

enum Semantic {
	semantic_code,
	semantic_comment,
	semantic_blank,
	semantic_null
};

typedef struct {
	char *name;
	char *language;
	enum Semantic semantic;
} State;

bool state_trumps_language(State *the_state, State *other_state);
void state_test(void);


#endif
