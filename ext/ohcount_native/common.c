#include "common.h"

void die(char *err, int exit_code) {
	fprintf(stderr, err);
	exit(exit_code);
}
