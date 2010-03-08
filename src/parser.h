// parser.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_PARSER_H
#define OHCOUNT_PARSER_H

#include "sourcefile.h"

/**
 * @page parser_doc Parser Documentation
 * @author Mitchell Foral
 *
 * @section overview Overview
 *
 * I will assume the reader has a decent knowledge of how Ragel works and the
 * Ragel syntax. If not, please review the Ragel manual found at:
 *   http://research.cs.queensu.ca/~thurston/ragel/
 *
 * All parsers must at least:
 *
 * @li Call a callback function when a line of code is parsed.
 * @li Call a callback function when a line of comment is parsed.
 * @li Call a callback function when a blank line is parsed.
 *
 * Additionally a parser can call the callback function for each position of
 * entities parsed.
 *
 * Take a look at 'c.rl' and even keep it open for reference when reading this
 * document to better understand how parsers work and how to write one.
 *
 * @section writing Writing a Parser
 *
 * First create your parser in 'src/parsers/'. Its name should be the language
 * you are parsing with a '.rl' extension. You will not have to manually compile
 * any parsers, as this is automatically for you. However, you do need to add
 * your parser to 'hash/parsers.gperf'.
 *
 * Every parser must have the following at the top:
 *
 * @include parser_doc_1
 *
 * And the following at the bottom:
 *
 * @include parser_doc_2
 *
 * (Your parser will go between these two blocks.)
 *
 * The code can be found in the existing 'c.rl' parser. You will need to change:
 * @li OHCOUNT_[lang]_PARSER_H - Replace [lang] with your language name. So if
 *   you are writing a C parser, it would be OHCOUNT_C_PARSER_H.
 * @li [lang]_LANG - Set the variable name to be [lang]_LANG and its value to be
 *   the name of your language to parse as defined in languages.h. [lang] is
 *   your language name. For C it would be C_LANG.
 * @li [lang]_entities - Set the variable name to be [lang]_entities (e.g.
 *   c_entries) The value is an array of string entities your language has. For
 *   example C has comment, string, number, etc. entities. You should definately
 *   have "space", and "any" entities. "any" entities are typically used for
 *   entity machines (discussed later) and match any character that is not
 *   recognized so the parser does not do something unpredictable.
 * @li enum - Change the value of the enum to correspond with your entities. So
 *   if in your parser you look up [lang]_entities[ENTITY], you will get the
 *   associated entity's string name.
 * @li parse_[lang] - Set the function name to parse_[lang] where again, [lang]
 *   is the name of your language. In the case of C, it is parse_c.
 * @li [lang]_en_[lang]_line - The line counting machine.
 * @li [lang]_en_[lang]_entity - The entity machine.
 *
 * You may be asking why you have to rename variables and functions. Well if
 * variables have the same name in header files (which is what parsers are), the
 * compiler complains. Also, when you have languages embedded inside each other,
 * any identifiers with the same name can easily be mixed up. It is also
 * important to prefix your Ragel definitions with your language to avoid
 * conflicts with other parsers.
 *
 * Additional variables available to parsers are in the parser_macros.h file.
 * Take a look at it and try to understand what the variables are used for. They
 * will make more sense later on.
 *
 * Now you can define your Ragel parser. Name your machine after your language,
 * "write data", and include 'common.rl', a file with common Ragel definitions,
 * actions, etc. For example:
 *
 * @include parser_doc_3
 *
 * Before you begin to write patterns for each entity in your language, you need
 * to understand how the parser should work.
 *
 * Each parser has two machines: one optimized for counting lines of code,
 * comments, and blanks; the other for identifying entity positions in the
 * buffer.
 *
 * @section line Line Counting Machine
 *
 * This machine should be written as a line-by-line parser for multiple lines.
 * This means you match any combination of entities except a newline up until
 * you do reach a newline. If the line contains only spaces, or nothing at all,
 * it is blank. If the line contains spaces at first, but then a comment, or
 * just simply a comment, the line is a comment. If the line contains anything
 * but a comment after spaces (if there are any), it is a line of code. You
 * will do this using a Ragel scanner. The callback function will be called for
 * each line parsed.
 *
 * @subsection line_scanner Scanner Parser Structure
 *
 * A scanner parser will look like this:
 *
 * @include parser_doc_4
 *
 * (As usual, replace [lang] with your language name.)
 *
 * Each entity is the pattern for an entity to match, the last one typically
 * being the newline entity. For each match, the variable is set to a constant
 * defined in the enum, and the main action is called (you will need to create
 * this action above the scanner).
 *
 * When you detect whether or not a line is code or comment, you should call the
 * appropriate \@code or \@comment action defined in 'common.rl' as soon as
 * possible. It is not necessary to worry about whether or not these actions are
 * called more than once for a given line; the first call to either sets the
 * status of the line permanently. Sometimes you cannot call \@code or \@comment
 * for one reason or another. Do not worry, as this is discussed later.
 *
 * When you reach a newline, you will need to decide whether the current line is
 * a line of code, comment, or blank. This is easy. Simply check if the
 * #line_contains_code or #whole_line_comment variables are set to 1. If neither
 * of them are, the line is blank. Then call the callback function (not action)
 * with an "lcode", "lcomment", or "lblank" string, and the start and end
 * positions of that line (including the newline). The start position of the
 * line is in the #line_start variable. It should be set at the beginning of
 * every line either through the \@code or \@comment actions, or manually in the
 * main action. Finally the #line_contains_code, #whole_line_comment, and
 * #line_start state variables must be reset. All this should be done within the
 * main action shown below. Note: For most parsers, the std_newline(lang) macro
 * is sufficient and does everything in the main action mentioned above. The
 * lang parameter is the [lang]_LANG string.
 *
 * @subsection line_action Main Action Structure
 *
 * The main action looks like this:
 *
 * @include parser_doc_5
 *
 * @subsection line_entity_patterns Defining Patterns for Entities
 *
 * Now it is time to write patterns for each entity in your language. That does
 * not seem very hard, except when your entity can cover multiple lines.
 * Comments and strings in particular can do this. To make an accurate line
 * counter, you will need to count the lines covered by multi-line entities.
 * When you detect a newline inside your multi-line entity, you should set the
 * entity variable to be #INTERNAL_NL and call the main action. The main action
 * should have a case for #INTERNAL_NL separate from the newline entity. In it,
 * you will check if the current line is code or comment and call the callback
 * function with the appropriate string ("lcode" or "lcomment") and beginning
 * and end of the line (including the newline). Afterwards, you will reset the
 * #line_contains_code and #whole_line_comment state variables. Then set the
 * #line_start variable to be #p, the current Ragel buffer position. Because
 * #line_contains_code and #whole_line_comment have been reset, any non-newline
 * and non-space character in the multi-line pattern should set
 * #line_contains_code or #whole_line_comment back to 1. Otherwise you would count
 * the line as blank.
 *
 * Note: For most parsers, the std_internal_newline(lang) macro is sufficient
 * and does everything in the main action mentioned above. The lang parameter
 * is the [lang]_LANG string.
 *
 * For multi-line matches, it is important to call the \@code or \@comment
 * actions (mentioned earlier) before an internal newline is detected so the
 * #line_contains_code and #whole_line_comment variables are properly set. For
 * other entities, you can use the #code macro inside the main action which
 * executes the same code as the Ragel \@code action. Other C macros are
 * #comment and #ls, the latter is typically used for the SPACE entity when
 * defining #line_start.
 *
 * Also for multi-line matches, it may be necessary to use the \@enqueue and
 * \@commit actions. If it is possible that a multi-line entity will not have an
 * ending delimiter (for example a string), use the \@enqueue action as soon as
 * the start delimitter has been detected, and the \@commit action as soon as
 * the end delimitter has been detected. This will eliminate the potential for
 * any counting errors.
 *
 * @subsection line_notes Notes
 *
 * You can be a bit sloppy with the line counting machine. For example the only
 * C entities that can contain newlines are strings and comments, so
 * #INTERNAL_NL would only be necessary inside them. Other than those, anything
 * other than spaces is considered code, so do not waste your time defining
 * specific patterns for other entities.
 *
 * @subsection line_embedded Parsers with Embedded Languages
 *
 * Notation: [lang] is the parent language, [elang] is the embedded language.
 *
 * To write a parser with embedded languages (such as HTML with embedded CSS and
 * Javascript), you should first \#include the parser(s) above your Ragel code.
 * The header file is "[elang]_parser.h".
 *
 * Next, after the inclusion of 'common.rl', add "#EMBED([elang])" on separate
 * lines for each embedded language. The build process looks for these special
 * comments to embed the language for you automatically.
 *
 * In your main action, you need to add another entity #CHECK_BLANK_ENTRY. It
 * should call the #check_blank_entry([lang]_LANG) macro. Blank entries are an
 * entry into an embedded language, but the rest of the line is blank before a
 * newline. For example, a CSS entry in HTML is something like:
 *
 * @code
 *   <style type="text/css">
 * @endcode
 *
 * If there is no CSS code after the entry (a blank entry), the line should be
 * counted as HTML code, and the #check_blank_entry macro handles this. But you
 * may be asking, "how do I get to the CHECK_BLANK_ENTRY entity?". This will be
 * discussed in just a bit.
 *
 * The #emb_newline and #emb_internal_newline macros should be used instead of
 * the #std_newline and #std_internal_newline macros.
 *
 * For each embedded language you will have to define an entry and outry. An
 * entry is the pattern that transitions from the parent language into the child
 * language. An outry is the pattern from child to parent. You will need to put
 * your entries in your [lang]_line machine. You will also need to re-create
 * each embedded language's line machine (define as [lang]_[elang]_line; e.g.
 * html_css_line) and put outry patterns in those. Entries typically would be
 * defined as [lang]_[elang]_entry, and outries as [lang]_[elang]_outry.
 *
 * Note: An outry should have a \@check_blank_outry action so the line is not
 * mistakenly counted as a line of embedded language code if it is actually a
 * line of parent code.
 *
 * @subsection line_entry_action Entry Pattern Actions
 *
 * @include parser_doc_6
 *
 * What this does is checks for a blank entry, and if it is, counts the line as
 * a line of parent language code. If it is not, the macro will not do anything.
 * The machine then transitions into the child language.
 *
 * @subsection line_outry_action Outry Pattern Actions
 *
 * @include parser_doc_7
 *
 * What this does is sets the current Ragel parser position to the beginning of
 * the outry so the line is counted as a line of parent language code if no
 * child code is on the same line. The machine then transitions into the parent
 * language.
 *
 * @section entity Entity Identifying Machine
 *
 * This machine does not have to be written as a line-by-line parser. It only
 * has to identify the positions of language entities, such as whitespace,
 * comments, strings, etc. in sequence. As a result they can be written much
 * faster and more easily with less thought than a line counter. Using a scanner
 * is most efficient. The callback function will be called for each entity
 * parsed.
 *
 * The \@ls, \@ code, \@comment, \@queue, and \@commit actions are completely
 * unnecessary.
 *
 * @subsection entity_scanner Scanner Structure
 *
 * @include parser_doc_8
 *
 * @subsection entity_action Main Action Structure
 *
 * @include parser_doc_9
 *
 * @subsection entity_embedded Parsers for Embedded Languages
 *
 * TODO:
 *
 * @section tests Including Written Tests for Parsers
 *
 * You should have two kinds of tests for parsers. One will be a header file
 * that goes in the 'test/unit/parsers/' directory and the other will be an
 * input source file that goes in the 'test/src_dir/' and an expected output
 * file that goes in the 'test/expected_dir/' directory.
 *
 * The header file will need to be "#include"ed in 'test/unit/parser_test.h'.
 * Then add the "all_[lang]_tests()" function to the "all_parser_tests()"
 * function.
 *
 * Recompile the tests for the changes to take effect.
 *
 * The other files added to the 'test/{src,expected}_dir/' directories will be
 * automatically detected and run with the test suite.
 */

/**
 * Tries to use an existing Ragel parser for the given language.
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @param count An integer flag indicating whether to count lines or parse
 *   entities.
 * @param callback A callback to use for every line or entity in the source
 *   file discovered (depends on count).
 * @param userdata Pointer to userdata used by callback (if any).
 * @return 1 if a Ragel parser is found, 0 otherwise.
 */
int ohcount_parse(SourceFile *sourcefile, int count,
                  void (*callback) (const char *, const char *, int, int,
                                    void *),
                  void *userdata);

#endif
