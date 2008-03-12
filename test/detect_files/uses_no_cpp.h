#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int superstat(const char * path, struct stat * buf);
