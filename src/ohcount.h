// ohcount.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_H
#define OHCOUNT_H

/**
 * @mainpage Ohcount
 *
 * The Ohloh source code line counter
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2 as
 * published by the Free Software Foundation.
 *
 * Ohcount is specifically licensed under GPL v2.0, and no later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @section overview Overview
 *
 * Ohcount is a program for counting lines of source code. It was originally
 * developed at Ohloh and used to generate the reports at www.ohloh.net
 *
 * Ohcount supports multiple languages within a single file: for example a
 * complex HTML document might include regions of both CSS and Javascript.
 *
 * Ohcount has 4 main components:
 *
 * @li A detector which determines the primary language family used by a
 *   particular source file.
 * @li A parser which provides a line-by-line breakdown of the contents of a
 *   source file.
 * @li Another detector which tries to determine the license(s) the source file
 *   is licensed under.
 * @li A final detector for gestalts (via the Ruby extension).
 *
 * The command line tool allows you to profile individual files or whole
 * directory trees.
 *
 * @section requirements System Requirements
 *
 * Ohcount is supported on Mac OSX 10.5 and Ubuntu 6.06 LTS. Other Linux
 * environments should also work, but your mileage may vary. Windows is not
 * supported.
 *
 * @section download Download
 *
 * Ohcount source code is available as a Git repository:
 *
 *   git clone git://ohcount.git.sourceforge.net/gitroot/ohcount/ohcount
 *
 * @section build Building Ohcount
 *
 * In order to build Ohcount, the following is required:
 *
 * @li GNU C compiler - http://gcc.gnu.org/
 * @li Ragel 6.3 or later - http://research.cs.queensu.ca/~thurston/ragel/
 * @li GNU gperf - http://www.gnu.org/software/gperf/
 * @li PCRE - http://pcre.sourceforge.net/
 * @li Bash - http://www.gnu.org/software/bash/
 *
 * Run the 'build' script to build Ohcount.
 *
 * @code
 * $ ./build
 * @endcode
 *
 * You may then link or copy 'bin/ohcount' to your system's PATH.
 *
 * Building the Ruby extension of Ohcount requires:
 *
 * @li Ruby - http://ruby-lang.org/
 * @li Swig - http://swig.org/
 *
 * @code
 * $ ./build ruby
 * @endcode
 *
 * You may then link or copy 'ruby/ohcount.{rb,so}' and 'ruby/gestalt{/,.rb}'
 * to the appropriate places in your Ruby installation.
 *
 * Building the Doxygen docs requires:
 *
 * @li Doxygen - http://www.doxygen.org/
 *
 * @code
 * $ cd doc
 * $ Doxygen Doxyfile
 * @endcode
 *
 * @section start First Steps
 *
 * To measure lines of code, simply pass file or directory names to the
 * bin/ohcount executable:
 *
 * @code
 * $ ohcount helloworld.c
 * @endcode
 *
 * Directories will be probed recursively. If you do not pass any parameters,
 * the current directory tree will be counted.
 *
 * You can use the ohcount 'detect' option to simply determine the language
 * family of each source file. The files will not be parsed or counted. For
 * example, to find all of the Ruby files in the current directory tree:
 *
 * @code
 * $ ohcount --detect | grep ^ruby
 * @endcode
 *
 * The 'annotate' option presents a line-by-line accounting of the languages
 * used in a source code file. For example:
 *
 * @code
 * $ ohcount --annotate ./test/src_dir/php1.php
 * @endcode
 *
 * More options can be found by typing:
 *
 * @code
 * $ ohcount --help
 * @endcode
 *
 * @section docs Additional Documentation
 *
 * See the Related Pages tab at the top of the page.
 *
 * @section contact Contact Ohloh
 *
 * For more information visit the Ohloh website: https://sourceforge.net/projects/ohcount
 *
 * You can reach Ohloh via email at: info@ohloh.net
 */

#define COMMAND_ANNOTATE 1
#define COMMAND_DETECT 2
#define COMMAND_HELP 3
#define COMMAND_INDIVIDUAL 4
#define COMMAND_LICENSES 5
#define COMMAND_RAWENTITIES 6
#define COMMAND_SUMMARY 7

#endif
