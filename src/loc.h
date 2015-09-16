// loc.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_LOC_H
#define OHCOUNT_LOC_H

#include "structs.h"

/**
 * Creates a new Loc from the given language, lines of code, comments, and
 * blanks, and number of files counted.
 * The given language is not copied and may not be 'free'd. Use a language
 * defined in src/languages.h.
 * @param language The language being counted.
 * @param code The number of lines of code counted.
 * @param comments The number of lines of comments counted.
 * @param blanks The number of blank lines counted.
 * @param filecount The number of files counted for this set.
 * @return Loc
 */
Loc *ohcount_loc_new(const char *language, int code, int comments, int blanks,
                     int filecount);

/**
 * Returns the total number of lines counted for a given Loc.
 * @param loc A Loc created from ohcount_loc_new().
 */
int ohcount_loc_total(Loc *loc);

/**
 * Adds a Loc to another, provided they use the same language.
 * The results are stored in the first Loc given. The second Loc may be 'free'd
 * immediately.
 * @param loc A Loc created from ohcount_loc_new().
 * @param other Another Loc.
 */
void ohcount_loc_add_loc(Loc *loc, Loc *other);

/**
 * Returns whether or not two given Locs are equivalent.
 * @param loc A Loc created from ohcount_loc_new().
 * @param other Another Loc.
 */
int ohcount_loc_is_equal(Loc *loc, Loc *other);

/**
 * Frees the memory allocated for a given Loc.
 * @param loc A Loc created from ohcount_loc_new().
 */
void ohcount_loc_free(Loc *loc);

/**
 * Creates a new LocList that is initially empty.
 * Locs can be added using ohcount_loc_list_add_loc().
 * @return LocList
 */
LocList *ohcount_loc_list_new();

/**
 * Adds a given Loc to a LocList.
 * The given Loc is copied and may be 'free'd immediately.
 * @param list a LocList created from ohcount_loc_list_new().
 * @param loc A Loc created from ohcount_loc_new().
 */
void ohcount_loc_list_add_loc(LocList *list, Loc *loc);

/**
 * Adds a given LocList to another LocList.
 * The results are stored in the first LocList given. The second LocList may be
 * 'free'd immediately.
 * @param list A LocList created from ohcount_loc_list_new().
 * @param loc_list Another LocList.
 */
void ohcount_loc_list_add_loc_list(LocList *list, LocList *loc_list);

/**
 * Returns a Loc from a given LocList and language.
 * The returned pointer is used internally and may not be 'free'd.
 * @param list A LocList created from ohcount_loc_list_new().
 * @param language The language of the Loc to retrieve.
 * @return Loc or NULL.
 */
Loc *ohcount_loc_list_get_loc(LocList *list, const char *language);

/**
 * Returns the number of lines of code for all Locs in this LocList.
 * @param list A LocList created from ohcount_loc_list_new().
 */
int ohcount_loc_list_code(LocList *list);

/**
 * Returns the number of lines of commentsfor all Locs in this LocList.
 * @param list A LocList created from ohcount_loc_list_new().
 */
int ohcount_loc_list_comments(LocList *list);

/**
 * Returns the number of blank lines for all Locs in this LocList.
 * @param list A LocList created from ohcount_loc_list_new().
 */
int ohcount_loc_list_blanks(LocList *list);

/**
 * Returns the total number of lines for all Locs in this LocList.
 * @param list A LocList created from ohcount_loc_list_new().
 */
int ohcount_loc_list_total(LocList *list);

/**
 * Returns the number of files counted for all Locs in this LocList.
 * @param list A LocList created from ohcount_loc_list_new().
 */
int ohcount_loc_list_filecount(LocList *list);

/**
 * Creates a new LocList from a given one, excluding all Locs with no counted
 * lines.
 * The given list may be 'free'd immediately.
 * @param list A LocList created from ohcount_loc_list_new().
 */
LocList *ohcount_loc_list_new_compact(LocList *list);

/**
 * Frees the memory allocated for a given LocList.
 * @param list A LocList created from ohcount_loc_list_new().
 */
void ohcount_loc_list_free(LocList *list);

/**
 * Creates a new LocDelta from the given language and lines of code, comments,
 * and blanks added and removed.
 * The given language is not copied and may not be 'free'd. Use a language
 * defined in src/languages.h.
 * @param language The language being counted.
 * @param code_added The number of lines of code added in this delta.
 * @param code_removed The number of lines of code removed in this delta.
 * @param comments_added The number of lines of comments added in this delta.
 * @param comments_removed The number of lines of comments removed in this
 *   delta.
 * @param blanks_added The number of blank lines added in this delta.
 * @param blanks_removed The number of blank lines removed in this delta.
 * @return LocDelta
 */
LocDelta *ohcount_loc_delta_new(const char *language, int code_added,
                                int code_removed, int comments_added,
                                int comments_removed, int blanks_added,
                                int blanks_removed);

/**
 * Returns the net number of lines of code in a given LocDelta.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
int ohcount_loc_delta_net_code(LocDelta *delta);

/**
 * Returns the net number of lines of comments in a given LocDelta.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
int ohcount_loc_delta_net_comments(LocDelta *delta);

/**
 * Returns the net number of blank lines in a given LocDelta.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
int ohcount_loc_delta_net_blanks(LocDelta *delta);

/**
 * Returns the net number of lines in a given LocDelta.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
int ohcount_loc_delta_net_total(LocDelta *delta);

/**
 * Adds a LocDelta to another, provided they use the same language.
 * The results are stored in the first LocDelta given. The second LocDelta may
 * be 'free'd immediately.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 * @param other Another LocDelta.
 */
void ohcount_loc_delta_add_loc_delta(LocDelta *delta, LocDelta *other);

/**
 * Returns whether or not a given LocDelta has any line changes.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
int ohcount_loc_delta_is_changed(LocDelta *delta);

/**
 * Returns whether or not two given LocDeltas are equivalent.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 * @param other Another LocDelta.
 */
int ohcount_loc_delta_is_equal(LocDelta *delta, LocDelta *other);

/**
 * Frees the memory allocated for a given LocDelta.
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
void ohcount_loc_delta_free(LocDelta *delta);

/**
 * Creates a new LocDeltaList that is initially empty.
 * LocDeltas can be added using ohcount&oc_delta_list_add_loc_delta().
 * @return LocDeltaList
 */
LocDeltaList *ohcount_loc_delta_list_new();

/**
 * Adds a given LocDelta to a LocDeltaList.
 * The given LocDelta is copied and may be 'free'd immediately.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 * @param delta A LocDelta created from ohcount_loc_delta_new().
 */
void ohcount_loc_delta_list_add_loc_delta(LocDeltaList *list, LocDelta *delta);

/**
 * Adds a given LocDeltaList to another LocDeltaList.
 * The results are stored in the first LocDeltaList given. The second
 * LocDeltaList may be 'free'd immediately.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 * @param loc_delta_list Another LocDeltaList.
 */
void ohcount_loc_delta_list_add_loc_delta_list(LocDeltaList *list,
                                               LocDeltaList *loc_delta_list);

/**
 * Returns a LocDelta from a given LocDeltaList and language.
 * The returned pointer is used internally and may not be 'free'd.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 * @param language The language of the LocDelta to retrieve.
 * @return LocDelta or NULL.
 */
LocDelta *ohcount_loc_delta_list_get_loc_delta(LocDeltaList *list,
                                               const char *language);

/**
 * Returns the number of lines of code added for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_code_added(LocDeltaList *list);

/**
 * Returns the number of lines of code removed for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_code_removed(LocDeltaList *list);

/**
 * Returns the number of lines of comments added for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_comments_added(LocDeltaList *list);

/**
 * Returns the number of lines of comments removed for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_comments_removed(LocDeltaList *list);

/**
 * Returns the number of blank lines added for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_blanks_added(LocDeltaList *list);

/**
 * Returns the number of blank lines removed for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_blanks_removed(LocDeltaList *list);

/**
 * Returns the net number of lines of code for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_net_code(LocDeltaList *list);

/**
 * Returns the net number of lines of comments for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_net_comments(LocDeltaList *list);

/**
 * Returns the net number of blank lines for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_net_blanks(LocDeltaList *list);

/**
 * Returns the net number of lines for the given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
int ohcount_loc_delta_list_net_total(LocDeltaList *list);

/**
 * Creates a new LocDeltaList from a given one, excluding all LocDeltas with no
 * counted lines.
 * The given list may be 'free'd immediately.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
LocDeltaList *ohcount_loc_delta_list_new_compact(LocDeltaList *list);

/**
 * Frees the memory allocated for a given LocDeltaList.
 * @param list A LocDeltaList created from ohcount_loc_delta_list_new().
 */
void ohcount_loc_delta_list_free(LocDeltaList *list);

#endif
