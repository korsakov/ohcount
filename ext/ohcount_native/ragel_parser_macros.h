// ragel_parser_macros.h written by Mitchell Foral. mitchell<att>caladbolg<dott>net

#ifndef RAGEL_PARSER_MACROS
#define RAGEL_PARSER_MACROS

/**
 * Callback struct for queues.
 * @field lang The Language name.
 * @field entity The entity name.
 * @field s The start position of the entity in the buffer.
 * @field e The end position of the entity in the buffer.
 * @field next The next Callback in the queue.
 */
typedef struct callback_list_item {
  const char *lang; // language name; should NOT be freed
  const char *entity; // entity name; should NOT be freed
  int s, e; // start and end positions of the entity in the buffer (use cint)
  struct callback_list_item *next; // the next callback to call
} Callback;

Callback *callback_list_head = NULL;
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
 */
void enqueue(const char *lang, const char *entity, int s, int e) {
  Callback *item = (Callback *) malloc(sizeof(Callback));
  if (!item) printf("Failed to allocate memory for enqueued callback.\n");

  item->lang = lang;
  item->entity = entity;
  item->s = s;
  item->e = e;
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
 */
#define ls { \
  if (inqueue) { dequeue; } \
  if (!line_start) line_start = ts; \
}

/**
 * The C equivalent of the Ragel 'code' action.
 * This is tyically used in the main action for entities where Ragel actions
 * cannot, for one reason or another, be used.
 */
#define code { \
  if (inqueue) { dequeue; } \
  if (!line_contains_code && !line_start) line_start = ts; \
  line_contains_code = 1; \
}

/**
 * The C equivalent of the Ragel 'comment' action.
 * This is typically unused, but here for consistency.
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
 */
#define std_internal_newline(lang) { \
  if (callback && p > line_start) { \
    if (line_contains_code) { \
      if (inqueue) \
        enqueue(lang, "lcode", cint(line_start), cint(p)); \
      else \
        callback(lang, "lcode", cint(line_start), cint(p)); \
    } else if (whole_line_comment) { \
      if (inqueue) \
        enqueue(lang, "lcomment", cint(line_start), cint(p)); \
      else \
        callback(lang, "lcomment", cint(line_start), cint(p)); \
    } else { \
      if (inqueue) \
        enqueue(lang, "lblank", cint(line_start), cint(p)); \
      else \
        callback(lang, "lblank", cint(line_start), cint(p)); \
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
 */
#define std_newline(lang) {\
  if (inqueue) { dequeue; } \
  if (callback && te > line_start) { \
    if (line_contains_code) \
      callback(lang, "lcode", cint(line_start), cint(te)); \
    else if (whole_line_comment) \
      callback(lang, "lcomment", cint(line_start), cint(te)); \
    else \
      callback(lang, "lblank", cint(ts), cint(te)); \
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
 */
#define process_last_line(lang) {\
  if ((whole_line_comment || line_contains_code) && callback) { \
    if (line_contains_code) \
      callback(lang, "lcode", cint(line_start), cint(pe)); \
    else if (whole_line_comment) \
      callback(lang, "lcomment", cint(line_start), cint(pe)); \
  } \
}

/**
 * Determines whether or not the rest of the line is blank.
 * This is typically used when entering an embedded language.
 * @param p The position of entry into the emebedded language.
 * @return 0 if the rest of the line is not blank, the position at the end of
 *   the newline otherwise (inclusive).
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
 */
#define check_blank_entry(lang) { \
  if (is_blank_entry(&p)) { \
    te = p + 1; \
    std_newline(lang) \
  } \
}

// Variables used by all parsers. Do not modify.

// used for newlines
#define NEWLINE -1

// used for newlines inside patterns like strings and comments that can have
// newlines in them
#define INTERNAL_NL -2

#define CHECK_BLANK_ENTRY -3

// required by Ragel
int cs, act;
char *p, *pe, *eof, *ts, *te;
int stack[5], top;

// used for calculating offsets from buffer start for start and end positions
char *buffer_start;
#define cint(c) ((int) (c - buffer_start))

// state flags for line and comment counting
int whole_line_comment;
int line_contains_code;

// the beginning of a line in the buffer for line and comment counting
char *line_start;

// state variable for the current entity being matched
int entity;

// keeps track of an embedded language
const char *seen;

// whether or not to enqueue callbacks instead of calling them in real time
int inqueue;

// backups for 'inqueue'ing
char *last_line_start;
int last_line_contains_code, last_whole_line_comment;

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
