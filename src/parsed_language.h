// parsed_language.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_PARSED_LANGUAGE_H
#define OHCOUNT_PARSED_LANGUAGE_H

#include "structs.h"

/**
 * Creates a new ParsedLanguage for the given language and buffer size.
 * The given language is not copied and may not be 'free'd. Use a language
 * defined in src/languages.h.
 * @param language The parsed language.
 * @param buffer_size The size of the buffers to store parsed code and comment
 *   text.
 * @return ParsedLanguage
 */
ParsedLanguage *ohcount_parsed_language_new(const char *language,
                                            int buffer_size);

/**
 * Adds some code to the code buffer for the given ParsedLanguage.
 * @param parsed_language A ParsedLanguage created from
 *   ohcount_parsed_language_new().
 * @param p A pointer in memory to start copying code from.
 * @param length The number of characters to copy from p.
 */
void ohcount_parsed_language_add_code(ParsedLanguage *parsed_language,
                                      char *p, int length);

/**
 * Adds a comment to the comment buffer for the given ParsedLanguage.
 * @param parsed_language A ParsedLanguage created from
 *   ohcount_parsed_language_new().
 * @param p A pointer in memory to start copying the comment from.
 * @param length The number of characters to copy from p.
 */
void ohcount_parsed_language_add_comment(ParsedLanguage *parsed_language,
                                         char *p, int length);

/**
 * Frees the memory allocated for the given ParsedLanguage.
 * @param parsed_language A ParsedLanguage created from
 *   ohcount_parsed_language_new().
 */
void ohcount_parsed_language_free(ParsedLanguage *parsed_language);

/**
 * Creates a new ParsedLanguageList that is initially empty.
 * @return ParsedLanguageList
 */
ParsedLanguageList *ohcount_parsed_language_list_new();

/**
 * Frees the memory allocated for the given ParsedLanguageList.
 * @param list A ParsedLanguage created from ohcount_parsed_language_list_new().
 */
void ohcount_parsed_language_list_free(ParsedLanguageList *list);

#endif
