// structs.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_STRUCTS_H
#define OHCOUNT_STRUCTS_H

#include <pcre.h>

/**
 * @struct License
 * @brief Holds a license and its associated details and patterns.
 */
typedef struct {
  /** The ID name of the license. Should be in defined in licenses.h. */
  const char *name;

  /** The string URL to the license's website. */
  const char *url;

  /** A nice displayable name for the license. */
  const char *nice_name;

  /** A PCRE regular expression for text that matches this license. */
  const char *re;

  /** PCRE flags for re. (Typically PCRE_CASELESS or PCRE_MULTILINE). */
  int re_flags;

  /**
   * A PCRE regular expression for text that matches re, but should not match
   * this re in order to match this license.
   */
  const char *exclude_re;

  /** PCRE flags for exclude_re. */
  int exclude_re_flags;

  /** The PCRE object for re. (This field is set automatically.) */
  pcre *regexp;

  /** The PCRE object for exclude_re. (This field is set automatically.) */
  pcre *exclude_regexp;

} License;

/**
 * @struct LicenseListItem
 * @brief Holds a list of Licenses in a linked list.
 */
typedef struct LicenseListItem {
  /** The particular License in this linked list item. */
  License *lic;

  /** The next LicenseList in the linked list. */
  struct LicenseListItem *next;

  /**
   * The head of the linked list this LicenseList item is part of.
   * This field is only used for the list head.
   */
  struct LicenseListItem *head;

  /**
   * The head of the linked list this LicenseList item is part of.
   * This field is only used for the list head.
   */
  struct LicenseListItem *tail;

} LicenseList;

/**
 * @struct Loc
 * @brief Tracks total lines of code, comments, and blanks for a single
 *   language.
 */
typedef struct {
  /** The language associated with this Loc. */
  const char *language;

  /** The number of lines of code for this Loc. */
  int code;

  /** The number of lines of comments for this Loc. */
  int comments;

  /** The number of blank lines for this Loc. */
  int blanks;

  /** The number of parsed files associated with this Loc. */
  int filecount;

} Loc;

/**
 * @struct LocListItem
 * @brief Tracks total lines of code, comments, and blanks for multiple
 *   languages using a linked list.
 */
typedef struct LocListItem {
  /** The particular Loc in this linked list item. */
  Loc *loc;

  /** The next LocList item in the linked list. */
  struct LocListItem *next;

  /**
   * The head of the linked list this LocList item is part of.
   * This field is only used for the list head.
   */
  struct LocListItem *head;

  /**
   * The tail of the linked list this LocList item is part of.
   * This field is only used for the list head.
   */
  struct LocListItem *tail;

} LocList;

/**
 * @struct LocDelta
 * @brief Tracks changes in lines of code, comments, and blank lines for a
 *   single language.
 */
typedef struct {
  /** The language associated with this LocDelta. */
  const char *language;

  /** The number of lines of code added in this LocDelta. */
  int code_added;

  /** The number of lines of code removed in this LocDelta. */
  int code_removed;

  /** The number of lines of comments added in this LocDelta. */
  int comments_added;

  /** The number of lines of comments removed in this LocDelta. */
  int comments_removed;

  /** The number of blank lines added in this LocDelta. */
  int blanks_added;

  /** The number of blank lines removed in this LocDelta. */
  int blanks_removed;

} LocDelta;

/**
 * @struct LocDeltaListItem
 * @brief Tracks changes in lines of code, comments, and blank lines for
 *   multiple languages using a linked list.
 */
typedef struct LocDeltaListItem {
  /** The particular LocDelta in this linked list item. */
  LocDelta *delta;

  /** The next LocDeltaList item in the linked list. */
  struct LocDeltaListItem *next;

  /**
   * The head of the linked list this item is part of.
   * This field is only used for the list head.
   */
  struct LocDeltaListItem *head;

  /**
   * The tail of the linked list this item is part of.
   * This field is only used for the list head.
   */
  struct LocDeltaListItem *tail;

} LocDeltaList;

/**
 * @struct ParsedLanguage
 * @brief Represents a single language parsed from a SourceFile.
 */
typedef struct {
  /** The parsed language. */
  const char *name;

  /** The size of the code and comments buffers. */
  int buffer_size;

  /** Buffer containing the code parsed out for this language. */
  char *code;

  /** Used for writing parsed code to the code buffer. */
  char *code_p;

  /** Number of lines of code for this language. */
  int code_count;

  /** Buffer containing the comments parsed out for this language. */
  char *comments;

  /** Used for writing parsed comments to the comment buffer. */
  char *comments_p;

  /** Number of lines of comments for this language. */
  int comments_count;

  /** Number of blank lines for this language. */
  int blanks_count;

} ParsedLanguage;

/**
 * @struct ParsedLanguageListItem
 * @brief Holds a set of ParsedLanguages in a linked list.
 */
typedef struct ParsedLanguageListItem {
  /** The particular ParsedLanguage in this linked list item. */
  ParsedLanguage *pl;

  /** The next ParsedLanguageList item in the linked list. */
  struct ParsedLanguageListItem *next;

  /**
   * The head of the linked list this ParsedLanguageList item is part of.
   * This field is only used for the list head.
   */
  struct ParsedLanguageListItem *head;

  /**
   * The tail of the linked list this ParsedLanguageList item is part of.
   * This field is only used for the list head.
   */
  struct ParsedLanguageListItem *tail;

} ParsedLanguageList;

/**
 * @struct SourceFile
 * @brief Represents a single source code file.
 */
typedef struct {
  /** The entire path to the file. */
  char *filepath;

  /**
    The last character address considered to be part of the directory path in
    filepath. This is an address in memory, not a length relative to filepath.
  */
  int dirpath;

  /** The filepath's filename. */
  char *filename;

  /** The filepath's file extension. */
  char *ext;

  /**
   * If filepath does not represent the real location of the file on disk, this
   * field does.
   */
  char *diskpath;

  // The following fields should not be accessed directly. Their accessor
  // functions should be used instead as labeled.

  /**
   * The contents of the file.
   * Do not use this field. Use ohcount_sourcefile_get_contents() instead.
   */
  char *contents;

  /**
   * The size of the file's contents in bytes.
   * Do not use this field. Use ohcount_sourcefile_get_contents_size() instead.
   */
  int size;

  /**
   * The file's detected source code language.
   * Do not use this field. Use ohcount_sourcefile_get_language() instead.
   */
  const char *language;

  /**
   * Flag used internally for keeping track of whether or not
   * ohcount_sourcefile_get_language() has been called for this file.
   */
  int language_detected;

  /**
   * A ParsedLanguageList resulting from parsing the file.
   * Do not use this field. Use ohcount_sourcefile_get_parsed_language_list()
   * instead.
   */
  ParsedLanguageList *parsed_language_list;

  /**
   * A LicenseList of licenses detected.
   * Do not use this field. Use ohcount_sourcefile_get_license_list() instead.
   */
  LicenseList *license_list;

  /**
   * A LocList of all lines of code in each language in the file.
   * Do not use this field. Use ohcount_sourcefile_get_loc_list() instead.
   */
  LocList *loc_list;

  /** A string array of all filenames in this file's directory. */
  char **filenames;

} SourceFile;

/**
 * @struct SourceFileListItem
 * @brief Contains a set of SourceFiles.
 */
typedef struct SourceFileListItem {
  /** The particular SourceFile in this linked list item. */
  SourceFile *sf;

  /** The next SourceFileList item in the linked list. */
  struct SourceFileListItem *next;

  /**
   * The head of the linked list this SourceFileList item is part of.
   * This field is only used for the list head.
   */
  struct SourceFileListItem *head;

  /**
   * The tail of the linked list this SourceFileList item is part of.
   * This field is only used for the list head.
   */
  struct SourceFileListItem *tail;

} SourceFileList;

#endif
