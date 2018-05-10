#include <stdio.h>
#include <stdlib.h>

#define LOG_FILE "/tmp/ohcount.log"
void log_it(char *log) {
	FILE *f = fopen(LOG_FILE, "a");
	fputs(log, f);
	fclose(f);
}


