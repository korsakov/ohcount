// diff.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_DIFF_H
#define OHCOUNT_DIFF_H

/**
 * Computes the diff between the lines of two given string buffers.
 * The results are stored in the passed integer pointers.
 * Note: The algorithm discussed mentions a check being performed to find lines
 * matched incorrectly due to hashing; it is not in this implementation.
 * @param from The diff 'from' buffer.
 * @param to The diff 'to' buffer.
 * @param added Int pointer the number of lines added result is stored to.
 * @param removed Int pointer the number of lines removed result is stored to.
 */
void ohcount_calc_diff(const char *from, const char *to, int *added,
                       int *removed);

#endif
