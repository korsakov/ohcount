// detector.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_DETECTOR_H
#define OHCOUNT_DETECTOR_H

/**
 * @page detector_doc Detector Documentation
 *
 * @section language How to Add a New Language
 *
 * @li Add your language to 'src/languages.h' and 'src/hash/languages.gperf'.
 * @li Update 'src/hash/extensions.gperf' to identify files that use the new
 *   language (or 'src/hash/filenames.gperf').
 * @li Regenerate the hash header files with 'src/hash/generate_headers'.
 * @li Add your tests to 'test/unit/detector_test.h', rebuild the tests, and
 *   run them to confirm the detector changes.
 * @li Follow the detailed instructions in the Parser Documentation.
 * @li Rebuild Ohcount.
 */

#include "sourcefile.h"

/**
 * Attempts to detect the programming language used by the given file.
 * The returned pointer is used internally and must not be 'free'd.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return pointer to a string with the detected language or NULL.
 */
const char *ohcount_detect_language(SourceFile *sourcefile);

int ohcount_is_binary_filename(const char *filename);

/* Exported for unit testing */
void escape_path(char *safe, const char *unsafe);

#endif
