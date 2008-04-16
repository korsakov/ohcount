# This is a makefile.

giant_space_monkey : giant_space_monkey.c
	$(CC) $(CFLAGS) -o $@ $?

