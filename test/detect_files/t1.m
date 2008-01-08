#include <stdio.h>
#include "Test.h"

@implementation Test : Object
{
  int x;
}

- init: (int)n 
{
  [super init];
  x = n;
  return self;
}

+ test: (int)n
{
  return [[self alloc] init: n];
}

- (int)x
{
  return x;
}

@end


int main (int argc, char **argv)
{
  printf ("%d!\n", [[Test test: 17231] x]);
}
