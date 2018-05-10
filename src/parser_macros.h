// parser_macros.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_PARSER_MACROS_H
#define OHCOUNT_PARSER_MACROS_H

#include <stdio.h>
#include <stdlib.h>

#include "languages.h"

/**
 * @struct CallbackItem
 * @brief Holds a series of callbacks for in a queue (linked list).
 */
typedef struct CallbackItem {
  /**
   * The language associated with this callback item.
   * Must not be 'free'd.
   */
  const char *lang;

  /**
   * The name of the entity associated with this callback.
   * Must not be 'free'd.
   */
  const char *entity;

  /** The start position of the entity in the buffer. */
  int s;

  /** The end position of the entity in the buffer. */
  int e;

  /** Userdata. */
  void *udata;

  /** The next callback in the linked list. */
  struct CallbackItem *next;

} Callback;

/** The head of the Callback queue. */
Callback *callback_list_head = NULL;

/** The tail of the Callback queue. */
Callback *callback_list_tail = NULL;

/**
 * Enqueues a callback for calling upon commit.
 * This is only necessary for line counting machines.
 * Ragel will execute actions in real-time rather than after a complete match.
 * This is a problem for entities that contain internal newlines, since there is
 * a callback for each internal newline whether or not the end of the entity
 * matches. This means that if, for example, the beginning of a string entity is
 * matched, the text following is treated as code until the ending delimiter. If
 * there is no ending delimiter (it was not actually a string entity), Ragel
 * will jump back to the beginning of the string and reparse the text again.
 * This means all the callbacks called were probably not accurate.
 * To remedy this, any entity which needs an ending delimiter that may not
 * appear will have its callbacks enqueued and then committed when the ending
 * delimitter is reached. If that delimitter is not reached, the callbacks are
 * never called.
 * @param lang The language name.
 * @param entity The entity (lcode, lcomment, lblank).
 * @param s The start position of the entity in the buffer.
 * @param e The end position of the entity in the buffer.
 * @param udata Userdata.
 */
void enqueue(const char *lang, const char *entity, int s, int e, void *udata) {
  Callback *item = (Callback *) malloc(sizeof(Callback));
  if (!item) printf("Failed to allocate memory for enqueued callback.\n");

  item->lang = lang;
  item->entity = entity;
  item->s = s;
  item->e = e;
  item->udata = udata;
  item->next = NULL;

  if (!callback_list_head) {
    callback_list_head = item;
    callback_list_tail = item;
  } else {
    callback_list_tail->next = item;
    callback_list_tail = item;
  }
}

/** Frees the memory used by a queue. */
void free_queue() {
  Callback *item = callback_list_head;
  while (item) {
    Callback *next = item->next;
    free(item);
    item = next;
  }
  callback_list_head = NULL;
  callback_list_tail = NULL;
}

/**
 * Restores settings for a failed enqueued entity.
 * This is typically used in the ls, code, and comment macros.
 * @note Applies only to line counting parsers.
 */
#define dequeue { \
  inqueue = 0; \
  line_start = last_line_start; \
  line_contains_code = last_line_contains_code; \
  whole_line_comment = last_whole_line_comment; \
}

/**
 * Sets the line_start variable to ts.
 * This is typically used for the SPACE entity in the main action.
 * @note Applies only to line counting parsers.
 */
#define ls { \
  if (inqueue) { dequeue; } \
  if (!line_start) line_start = ts; \
}

/**
 * The C equivalent of the Ragel 'code' action.
 * This is tyically used in the main action for entities where Ragel actions
 * cannot, for one reason or another, be used.
 * @note Applies only to line counting parsers.
 */
#define code { \
  if (inqueue) { dequeue; } \
  if (!line_contains_code && !line_start) line_start = ts; \
  line_contains_code = 1; \
}

/**
 * The C equivalent of the Ragel 'comment' action.
 * This is typically unused, but here for consistency.
 * @note Applies only to line counting parsers.
 */
#define comment { \
  if (inqueue) { dequeue; } \
  if (!line_contains_code) { \
    whole_line_comment = 1; \
    if (!line_start) line_start = ts; \
  } \
}

/**
 * Sets up for having seen an embedded language.
 * This is typically used when entering an embedded language which usually does
 * not span multiple lines (e.g. php for <?php echo 'blah' ?> on single lines)
 * so the line is counted as embedded code or comment, not parent code.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define saw(lang) { \
  seen = lang; \
  whole_line_comment = 0; \
  line_contains_code = 0; \
}

/**
 * Executes standard line counting actions for INTERNAL_NL entities.
 * This is typically used in the main action for the INTERNAL_NL entity.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define std_internal_newline(lang) { \
  if (callback && p > line_start) { \
    if (line_contains_code) { \
      if (inqueue) \
        enqueue(lang, "lcode", cint(line_start), cint(p), userdata); \
      else \
        callback(lang, "lcode", cint(line_start), cint(p), userdata); \
    } else if (whole_line_comment) { \
      if (inqueue) \
        enqueue(lang, "lcomment", cint(line_start), cint(p), userdata); \
      else \
        callback(lang, "lcomment", cint(line_start), cint(p), userdata); \
    } else { \
      if (inqueue) \
        enqueue(lang, "lblank", cint(line_start), cint(p), userdata); \
      else \
        callback(lang, "lblank", cint(line_start), cint(p), userdata); \
    } \
  } \
  whole_line_comment = 0; \
  line_contains_code = 0; \
  line_start = p; \
}

/**
 * Executes emebedded language line counting actions for INTERNAL_NL entities
 * based on whether or not the embedded language's code has been seen in a
 * parent line.
 * This is typically used in the main action for the INTERNAL_NL entity.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define emb_internal_newline(lang) { \
  if (seen && seen != lang) \
    std_internal_newline(seen) \
  else \
    std_internal_newline(lang) \
  seen = 0; \
}

/**
 * Executes standard line counting actions for NEWLINE entities.
 * This is typically used in the main action for the NEWLINE entity.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define std_newline(lang) {\
  if (inqueue) { dequeue; } \
  if (callback && te > line_start) { \
    if (line_contains_code) \
      callback(lang, "lcode", cint(line_start), cint(te), userdata); \
    else if (whole_line_comment) \
      callback(lang, "lcomment", cint(line_start), cint(te), userdata); \
    else \
      callback(lang, "lblank", cint(ts), cint(te), userdata); \
  } \
  whole_line_comment = 0; \
  line_contains_code = 0; \
  line_start = 0; \
}

/**
 * Executes embedded language line counting actions for NEWLINE entities based
 * on whether or not the embedded language's code has been seen in a parent
 * line.
 * This is typically used in the main action for the NEWLINE entity.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define emb_newline(lang) { \
  if (seen && seen != lang) \
    std_newline(seen) \
  else \
    std_newline(lang) \
  seen = 0; \
}

/**
 * Processes the last line for buffers that don't have a newline at EOF.
 * This is typically used at the end of the parse_lang function after the Ragel
 * parser has been executed.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define process_last_line(lang) {\
  if ((whole_line_comment || line_contains_code) && callback) { \
    if (line_contains_code) \
      callback(lang, "lcode", cint(line_start), cint(pe), userdata); \
    else if (whole_line_comment) \
      callback(lang, "lcomment", cint(line_start), cint(pe), userdata); \
  } \
}

/**
 * Determines whether or not the rest of the line is blank.
 * This is typically used when entering an embedded language.
 * @param p The position of entry into the emebedded language.
 * @return 0 if the rest of the line is not blank, the position at the end of
 *   the newline otherwise (inclusive).
 * @note Applies only to line counting parsers.
 */
int is_blank_entry(char **p) {
  char *pos = *p+1;
  while (*pos != '\n' && *pos != '\r' && *pos != '\f') {
    if (*pos != '\t' && *pos != ' ') return 0;
    pos++;
  }
  if (*pos == '\r' && *(pos+1) == '\n') pos++;
  *p = pos;
  return 1;
}

/**
 * If there is a transition into an embedded language and there is only parent
 * language code on the line (the rest of the line is blank with no child code),
 * count the line as a line of parent code.
 * Moves p and te to the end of the newline and calls the std_newline macro. (p
 * is inclusive, te is not.)
 * This is typically used in the main action for the CHECK_BLANK_ENTRY entity.
 * @param lang The language name string.
 * @note Applies only to line counting parsers.
 */
#define check_blank_entry(lang) { \
  if (is_blank_entry(&p)) { \
    te = p + 1; \
    std_newline(lang) \
  } \
}

// Variables used by all parsers. Do not modify.

/**
 * Newline entity.
 * @note This is only used for line counting parsers.
 */
#define NEWLINE -1

/**
 * Internal newline entity.
 * Used for newlines inside patterns like strings and comments that can have
 * newlines in them.
 * @note This is only used for line counting parsers.
 */
#define INTERNAL_NL -2

/**
 * Check blank entry entity.
 * Used for embedded language transitions. If a newline follows immediately
 * after such a transition, the line should be counted as parent code, not
 * child code.
 * @note This is only used for line counting parsers.
 */
#define CHECK_BLANK_ENTRY -3

/** Required by Ragel. */
int cs;

/** Required by Ragel. */
int act;

/** Required by Ragel. */
char *p;

/** Required by Ragel. */
char *pe;

/** Required by Ragel. */
char *eof;

/** Required by Ragel. */
char *ts;

/** Required by Ragel. */
char *te;

/** Required by Ragel. */
int stack[5];

/** Required by Ragel. */
int top;

/** The buffer currently being parsed. */
char *buffer_start;

/**
 * Returns the absolute location in memory for a position relative to the start
 * of the buffer being parsed.
 * @param c Position relative to the start of the buffer.
 * @note This is only used for line counting parsers.
 */
#define cint(c) ((int) (c - buffer_start))

/**
 * Flag indicating whether or not the current line contains only a comment.
 * @note This is only used for line counting parsers.
 */
int whole_line_comment;

/**
 * Flag indicating whether or not the current line contains any code.
 * @note This is only used for line counting parsers.
 */
int line_contains_code;

/**
 * The beginning of the current line in the buffer being parsed.
 * @note This is only used for line counting parsers.
 */
char *line_start;

/** State variable for the current entity being matched. */
int entity;

/**
 * Keeps track of an embedded language.
 * @note This is only used for line counting parsers.
 */
const char *seen;

/**
 * Flag indicating whether or not to enqueue callbacks instead of calling them
 * in real time.
 * @note This is only used for line counting parsers.
 */
int inqueue;

/**
 * Backup variable for 'inqueue'ing.
 * @note This is only used for line counting parsers.
 */
char *last_line_start;

/**
 * Backup variable for 'inqueue'ing.
 * @note This is only used for line counting parsers.
 */
int last_line_contains_code;

/**
 * Backup variable for 'inqueue'ing.
 * @note This is only used for line counting parsers.
 */
int last_whole_line_comment;

/**
 * Initializes variables for parsing a buffer.
 * Required at the beginning of every parser function.
 */
#define init { \
  p = buffer; \
  pe = buffer + length; \
  eof = pe; \
  \
  buffer_start = buffer; \
  whole_line_comment = 0; \
  line_contains_code = 0; \
  line_start = 0; \
  entity = 0; \
  seen = 0; \
  inqueue = 0; \
}

#endif
