// sourcefile.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_SOURCEFILE_H
#define OHCOUNT_SOURCEFILE_H

#include "loc.h"
#include "parsed_language.h"

/**
 * Creates and returns a new SourceFile from a given filepath.
 * The given filepath is copied and may be 'free'd immediately.
 * @param filepath The path to a file on disk.
 * @return SourceFile
 */
SourceFile *ohcount_sourcefile_new(const char *filepath);

/**
 * Sets the filepath on the disk of the given SourceFile.
 * This is only used if the SourceFile's filepath field is not accurate,
 * typically only in language detection.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @param diskpath The real path to the file on disk.
 */
void ohcount_sourcefile_set_diskpath(SourceFile *sourcefile,
                                     const char *diskpath);

/**
 * Sets the contents of the given SourceFile.
 * The given contents are copied and may be 'free'd immediately.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @param contents The contents to set for sourcefile.
 */
void ohcount_sourcefile_set_contents(SourceFile *sourcefile,
                                     const char *contents);

/**
 * Returns the file contents of a given SourceFile.
 * The returned pointer is used internally and may not be 'free'd.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return pointer to string file contents.
 */
char *ohcount_sourcefile_get_contents(SourceFile *sourcefile);

/**
 * Returns the size of the file contents of a given SourceFile.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return size of the file's contents.
 */
int ohcount_sourcefile_get_contents_size(SourceFile *sourcefile);

/**
 * Sets the language of a given SourceFile.
 * The given language copied and may be 'free'd immediately.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @param language The language to set the SourceFile to.
 */
void ohcount_sourcefile_set_language(SourceFile *sourcefile,
                                     const char *language);

/**
 * Returns the detected language of a given SourceFile.
 * The returned pointer is used internally and may not be 'free'd.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return string language name.
 */
const char *ohcount_sourcefile_get_language(SourceFile *sourcefile);

/**
 * Parses the given SourceFile with the default callback that keeps track of the
 * number of lines of code, comments, and blank lines.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 */
void ohcount_sourcefile_parse(SourceFile *sourcefile);

/**
 * Returns the ParsedLanguageList parsed out of the given SourceFile.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return ParsedLanguageList
 */
ParsedLanguageList *ohcount_sourcefile_get_parsed_language_list(SourceFile
                                                                *sourcefile);

/**
 * Parses the given SourceFile with a specific callback.
 * The callback is called for each line parsed, not entity.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @param callback The callback function to call for every line parsed.
 * @param userdata Userdata to pass to the callback function.
 */
void ohcount_sourcefile_parse_with_callback(SourceFile *sourcefile,
                                            void (*callback) (const char *,
                                                              const char *, int,
                                                              int, void *),
                                            void *userdata);

/**
 * Parses the given SourceFile with a specific callback.
 * The callback is called for each entity parsed, not line.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @param callback The callback function to call for every entity parsed.
 * @param userdata Userdata to pass to the callback function.
 */
void ohcount_sourcefile_parse_entities_with_callback(SourceFile *sourcefile,
                                                     void (*callback)
                                                       (const char *,
                                                        const char *, int,
                                                        int, void *),
                                                     void *userdata);

/**
 * Returns a LicenseList of detected licenses in the given SourceFile.
 * The returned list and its contents are used internally and may not be
 * 'free'd.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return LicenseList
 */
LicenseList *ohcount_sourcefile_get_license_list(SourceFile *sourcefile);

/**
 * Returns a LocList of total lines of code in each language in the given
 * SourceFile.
 * The returned list and its contents are used internally and may not be
 * 'free'd.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return LocList
 */
LocList *ohcount_sourcefile_get_loc_list(SourceFile *sourcefile);

/**
 * Returns a LocDeltaList reflecting the changes from one revision of a
 * SourceFile to another for all languages.
 * The returned pointer must be 'free'd.
 * @param from The reference SourceFile created by ohcount_sourcefile_new().
 * @param to The SourceFile to compare the reference SourceFile to (typically a
 *   later revision instead of a completely different SourceFile).
 * @return LocDeltaList
 */
LocDeltaList *ohcount_sourcefile_diff(SourceFile *from, SourceFile *to);

/**
 * Returns a LocDelta reflecting the changes from one revision of a SourceFile
 * to another for a given language.
 * The given language is not copied and may not be 'free'd. Use a language
 * defined in src/languages.h.
 * The returned pointer must be 'free'd.
 * @param from The reference SourceFile created by ohcount_sourcefile_new().
 * @param language The language to calculate the LocDelta from.
 * @param to The SourceFile to compare the reference SourceFile to (typically a
 *   later revision instead of a completely different SourceFile).
 * @return LocDelta
 */
LocDelta *ohcount_sourcefile_calc_loc_delta(SourceFile *from,
                                            const char *language,
                                            SourceFile *to);

/**
 * Frees a SourceFile created by ohcount_sourcefile_new().
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 */
void ohcount_sourcefile_free(SourceFile *sourcefile);

/**
 * Creates a new SourceFileList that is initially empty.
 * Files can be added using ohcount_sourcefile_list_add_file().
 * Directories can be added using ohcount_sourcefile_list_add_directory().
 * @return SourceFileList
 */
SourceFileList *ohcount_sourcefile_list_new();

/**
 * Adds a given file to a SourceFileList.
 * The given filepath is copied and may be 'free'd immediately.
 * @param list a SourceFileList created by ohcount_sourcefile_list_new().
 * @param filepath The full path to the file to be added to the list.
 */
void ohcount_sourcefile_list_add_file(SourceFileList *list,
                                          const char *filepath);

/**
 * Adds the contents of a given directory to a SourceFileList.
 * The given directory may be 'free'd immediately.
 * @param list A SourceFileList created by ohcount_sourcefile_list_new().
 * @param directory The directory whose contents are to be added to the list.
 */
void ohcount_sourcefile_list_add_directory(SourceFileList *list,
                                           const char *directory);

/**
 * Returns a new LocList for all files in the given SourceFileList.
 * @param list A SourceFileList created by ohcount_sourcefile_list_new().
 * @return LocList
 */
LocList *ohcount_sourcefile_list_analyze_languages(SourceFileList *list);

/**
 * Frees the memory allocated for a given SourceFileList.
 * @param list A SourceFileList created by ohcount_sourcefile_list_new().
 */
void ohcount_sourcefile_list_free(SourceFileList *list);

#endif
