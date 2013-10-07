#include <stddef.h>
#include "lexer.h"
#include "ast.h"
#include "const.h"


extern YYSTYPE yylval;
extern size_t yyleng;
extern char *buffer;

static struct tree_node *last_token = NULL;

static int line = 1, column = 0, buffer_pos = 0;


/**
 * @brief Advance the cursor to the next token.
 */
static void move(void) {

    column += yyleng;
    buffer_pos += yyleng;
}

/**
 * @brief Create a new node with the current token.
 */
static void save(void) {

    yylval = ast_new_node();

    yylval->text   = buffer + buffer_pos;
    yylval->length = yyleng;

    yylval->line_from = line;
    yylval->line_to   = line;
    yylval->col_from  = column;
    yylval->col_to    = column + yyleng - 1;

    yylval->child_count = 0;

    yylval->prev_token = last_token;

    if (last_token) {
        last_token->next_token = yylval;
    }

    last_token = yylval;
}

/**
 * @brief Process a keyword.
 * @param keyword - Constant for the keyword.
 * @returns which keyword.
 */
static int proc_keyword(int keyword) {

    save();

    yylval->node_type = AST_KEYWORD;
    yylval->node_subtype = keyword;

    move();

    return keyword;
}

/**
 * @brief Process a punctuator.
 * @param punctuator - Constant for the punctuator.
 * @returns which punctuator.
 */
static int proc_punctuator(int punctuator) {

    save();

    yylval->node_type = AST_PUNCTUATOR;
    yylval->node_subtype = punctuator;

    move();

    return punctuator;
}

/**
 * @brief Process an identifier.
 * @returns identifier.
 */
static int proc_identifier(void) {

/* TODO: test for TYPE_NAME */

    save();

    yylval->node_type = AST_IDENTIFIER;

    move();

    return IDENTIFIER;
}

/**
 * @brief Process a constant.
 * @param type - Constant type.
 * @param modifiers - Constant modifiers.
 * @param suffix_len - Length of modifiers string.
 * @returns constant.
 */
static int proc_constant(int type, int modifiers, int suffix_len) {

/* TODO: do a proper type analysis */

    save();

    yylval->node_type = AST_CONSTANT;
    yylval->node_subtype = type;
    yylval->data_type = modifiers;

    move();

    return CONSTANT;
}

/**
 * @brief Process a string literal.
 * @param modifiers - String modifiers.
 * @param prefix_len - Length of modifiers string.
 * @returns string literal.
 */
static int proc_string_literal(int modifiers, int prefix_len) {

/* TODO: do a proper type analysis */

    save();

    yylval->node_type = AST_STRING_LITERAL;
    yylval->data_type = modifiers;

    move();

    return STRING_LITERAL;
}

/**
 * @brief Process whitespace.
 */
static void proc_whitespace(void) {

    save();

    yylval->node_type = AST_WHITESPACE;

    move();
}

/**
 * @brief Process a preprocessor directive.
 */
static void proc_directive(void) {

    save();

    yylval->node_type = AST_DIRECTIVE;

    move();
}

/**
 * @brief Process an unexpected token.
 */
static void proc_unexpected_token(void) {

    save();

    yylval->node_type = AST_ERROR;
    yylval->node_subtype = AST_ER_UNEXPECTED_TOKEN;

    move();
}

/**
 * @brief Process a new line character.
 */
void proc_new_line(void) {

    column = 0;
    line++;
    buffer_pos++;
}
