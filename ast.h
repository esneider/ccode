#ifndef __AST_H__
#define __AST_H__


#include <stddef.h>
#include "parser.tab.h"

#define YYSTYPE struct ast_node*


struct ast_node {

    /* Text and position */

    char *text;    // pointer to string in input
    int length;    // length of string in input

    int line_from; // starting line in input
    int line_to;   // ending line in input
    int col_from;  // starting column in input
    int col_to;    // ending column in input

    struct ast_node *prev_token; // previous parsed token in input
    struct ast_node *next_token; // next parsed token in input

    /* Data type */

    int data_type;

    /* Node type */

    int node_type;    // @see enum ast_node_type
    int node_subtype; // @see enum ast_node_type

    /* Syntax tree */

    int child_count;

    struct ast_node *parent;
    struct ast_node *first_child;
    struct ast_node *last_child;
    struct ast_node *prev_sibling;
    struct ast_node *next_sibling;
};

enum ast_token {

    AST_NONE = 0,
    AST_WHITESPACE,
    AST_DIRECTIVE,
    AST_IDENTIFIER,
    AST_TYPEDEF_NAME,
    AST_STRING_LITERAL,
    AST_CONSTANT,

        AST_CN_INTEGER,
        AST_CN_UNSIGNED,
        AST_CN_FLOATING,
        AST_CN_CHARACTER,

    AST_KEYWORD,

        AST_KW_AUTO        = AUTO,
        AST_KW_BREAK       = BREAK,
        AST_KW_CASE        = CASE,
        AST_KW_CHAR        = CHAR,
        AST_KW_CONST       = CONST,
        AST_KW_CONTINUE    = CONTINUE,
        AST_KW_DEFAULT     = DEFAULT,
        AST_KW_DO          = DO,
        AST_KW_DOUBLE      = DOUBLE,
        AST_KW_ELSE        = ELSE,
        AST_KW_ENUM        = ENUM,
        AST_KW_EXTERN      = EXTERN,
        AST_KW_FLOAT       = FLOAT,
        AST_KW_FOR         = FOR,
        AST_KW_GOTO        = GOTO,
        AST_KW_IF          = IF,
        AST_KW_INLINE      = INLINE,
        AST_KW_INT         = INT,
        AST_KW_LONG        = LONG,
        AST_KW_REGISTER    = REGISTER,
        AST_KW_RESTRICT    = RESTRICT,
        AST_KW_RETURN      = RETURN,
        AST_KW_SHORT       = SHORT,
        AST_KW_SIGNED      = SIGNED,
        AST_KW_SIZEOF      = SIZEOF,
        AST_KW_STATIC      = STATIC,
        AST_KW_STRUCT      = STRUCT,
        AST_KW_SWITCH      = SWITCH,
        AST_KW_TYPEDEF     = TYPEDEF,
        AST_KW_UNION       = UNION,
        AST_KW_UNSIGNED    = UNSIGNED,
        AST_KW_VOID        = VOID,
        AST_KW_VOLATILE    = VOLATILE,
        AST_KW_WHILE       = WHILE,
        AST_KW__BOOL       = _BOOL,
        AST_KW__COMPLEX    = _COMPLEX,
        AST_KW__IMAGINARY  = _IMAGINARY,

    AST_PUNCTUATOR,

        AST_PT_RSQ_BRACKET = '[',
        AST_PT_LSQ_BRAQUET = ']',
        AST_PT_RRD_BRACKET = '(',
        AST_PT_LRD_BRACKET = ')',
        AST_PT_RCU_BRACKET = '{',
        AST_PT_LCU_BRACKET = '|',
        AST_PT_MEMBER      = '.',
        AST_PT_AND         = '&',
        AST_PT_MUL         = '*',
        AST_PT_ADD         = '+',
        AST_PT_SUB         = '-',
        AST_PT_COMMA       = ',',
        AST_PT_HASH        = '#',
        AST_PT_COMPL       = '~',
        AST_PT_NOT         = '!',
        AST_PT_DIV         = '/',
        AST_PT_MOD         = '%',
        AST_PT_LESS        = '<',
        AST_PT_MORE        = '>',
        AST_PT_XOR         = '^',
        AST_PT_OR          = '|',
        AST_PT_COND        = '?',
        AST_PT_COLON       = ':',
        AST_PT_SEMICOLON   = ';',
        AST_PT_ASSIGN      = '=',
        AST_PT_LOGICAL_AND = LOGICAL_AND,
        AST_PT_LOGICAL_OR  = LOGICAL_OR,
        AST_PT_ELLIPSIS    = ELLIPSIS,
        AST_PT_MUL_ASSIGN  = MUL_ASSIGN,
        AST_PT_DIV_ASSIGN  = DIV_ASSIGN,
        AST_PT_MOD_ASSIGN  = MOD_ASSIGN,
        AST_PT_ADD_ASSIGN  = ADD_ASSIGN,
        AST_PT_SUB_ASSIGN  = SUB_ASSIGN,
        AST_PT_LESS_EQUAL  = LESS_EQUAL,
        AST_PT_MORE_EQUAL  = MORE_EQUAL,
        AST_PT_EQUAL       = EQUAL,
        AST_PT_NOT_EQUAL   = NOT_EQUAL,
        AST_PT_LSHIFT_ASSIGN = LSHIFT_ASSIGN,
        AST_PT_RSHIFT_ASSIGN = RSHIFT_ASSIGN,
        AST_PT_AND_ASSIGN  = AND_ASSIGN,
        AST_PT_XOR_ASSIGN  = XOR_ASSIGN,
        AST_PT_OR_ASSIGN   = OR_ASSIGN,
        AST_PT_PASTE       = PASTE,
        AST_PT_POINTER     = POINTER,
        AST_PT_INC         = INCREMENT,
        AST_PT_DEC         = DECREMENT,
        AST_PT_LSHIFT      = LSHIFT,
        AST_PT_RSHIFT      = RSHIFT,
};

enum ast_expression {

    AST_EXPRESSION = 10000,

        AST_EX_CONSTANT,         // [AST_CONSTANT]
        AST_EX_IDENTIFIER,       // [AST_IDENTIFIER]
        AST_EX_STRING_LITERAL,   // [AST_STRING_LITERAL]
        AST_EX_EXPRESSION,       // [AST_EXPRESSION]
        AST_EX_ARRAY_SUBSCRIPTING, // [AST_EXPRESSION, AST_EXPRESSION]
        AST_EX_FUNCTION_CALL,    // [AST_EXPRESSION +]
        AST_EX_MEMBER,           // [AST_EXPRESSION, AST_IDENTIFIER]
        AST_EX_POINTER_MEMBER,   // [AST_EXPRESSION, AST_IDENTIFIER]
        AST_EX_COMPOUND_LITERAL, // [AST_TYPE_NAME, AST_INITIALIZER *]
        AST_EX_SIZEOF_EXPRESSION,// [AST_EXPRESSION]
        AST_EX_SIZEOF_TYPE_NAME, // [AST_TYPE_NAME]
        AST_EX_UNARY_PREFIX,     // [AST_PUNCTUATOR, AST_EXPRESSION]
        AST_EX_UNARY_POSTFIX,    // [AST_EXPRESSION, AST_PUNCTUATOR]
        AST_EX_CAST,             // [AST_TYPE_NAME, AST_EXPRESSION]
        AST_EX_BINARY,           // [AST_EXPRESSION, AST_PUNCTUATOR, AST_EXPRESSION]
        AST_EX_CONDITIONAL,      // [AST_EXPRESSION, AST_EXPRESSION, AST_EXPRESSION]
        AST_EX_ASSIGNMENT,       // [AST_EXPRESSION, AST_PUNCTUATOR, AST_EXPRESSION]
        AST_EX_COMMA,            // [AST_EXPRESSION, AST_EXPRESSION]
};

enum ast_declaration {

    AST_DECLARATION = 20000,     // [AST_DECLARATION_SPECIFIER_LIST, AST_INIT_DECLARATOR *]
    AST_DECLARATION_SPECIFIER_LIST, // [AST_DECLARATION_SPECIFIER +]
    AST_DECLARATION_SPECIFIER,

        AST_SP_STORAGE_CLASS,    // [AST_KEYWORD]
        AST_SP_TYPE,             // [AST_KEYWORD | AST_TYPEDEF_NAME | AST_STRUCT_OR_UNION_SPECIFIER | AST_ENUM_SPECIFIER]
        AST_QU_TYPE,             // [AST_KEYWORD]
        AST_SP_FUNCTION,         // [AST_KEYWORD]

    AST_INIT_DECLARATOR,         // [AST_DECLARATOR, AST_INITIALIZER ?]
    AST_STRUCT_OR_UNION_SPECIFIER,

        AST_SU_DECLARATION,      // [AST_KEYWORD, AST_IDENTIFIER]
        AST_SU_DEFINITION,       // [AST_KEYWORD, AST_IDENTIFIER ?, AST_STRUCT_DECLARATION +]

    AST_STRUCT_DECLARATION,      // [AST_DECLARATION_SPECIFIER_LIST, AST_STRUCT_DECLARATOR +]
    AST_STRUCT_DECLARATOR,       // [AST_DECLARATOR ?, AST_EXPRESSION ?]
    AST_ENUM_SPECIFIER,

        AST_EN_DECLARATION,      // [AST_IDENTIFIER]
        AST_EN_DEFINITION,       // [AST_IDENTIFIER ?, AST_ENUMERATOR +]

    AST_ENUMERATOR,              // [AST_IDENTIFIER, AST_EXPRESSION ?]
    AST_DECLARATOR,              // [AST_POINTER ?, AST_DIRECT_DECLARATOR +]
    AST_DIRECT_DECLARATOR,

        AST_DD_IDENTIFIER,       // []
        AST_DD_DECLARATOR,       // [AST_DECLARATOR]
        AST_DD_ARRAY,            // [AST_EXPRESSION ?, AST_QU_TYPE *]
        AST_DD_STATIC_ARRAY,     // [AST_EXPRESSION, AST_QU_TYPE *]
        AST_DD_STAR_ARRAY,       // [AST_QU_TYPE *]
        AST_DD_FUNCTION,         // [AST_PARAMETER_DECLARATION +]
        AST_DD_VA_ARG_FUNCTION,  // [AST_PARAMETER_DECLARATION +]
        AST_DD_OLD_FUNCTION,     // [AST_IDENTIFIER *]

    AST_PARAMETER_DECLARATION,

        AST_PA_DECLARATION,      // [AST_DECLARATION_SPECIFIER_LIST, AST_DECLARATOR]
        AST_PA_ABSTRACT_DECLARATION, // [AST_DECLARATION_SPECIFIER_LIST, AST_ABSTRACT_DECLARATOR ?]

    AST_POINTER,                 // [AST_QUALIFIER_LIST +]
    AST_QUALIFIER_LIST,          // [AST_QU_TYPE *]
    AST_TYPE_NAME,               // [AST_SPECIFIER_QUALIFIER_LIST, AST_ABSTRACT_DECLARATOR ?]
    AST_ABSTRACT_DECLARATOR,     // [AST_POINTER ?, AST_DIRECT_ABSTRACT_DECLARATOR *]
    AST_DIRECT_ABSTRACT_DECLARATOR,

        AST_DA_DECLARATOR,       // [AST_ABSTRACT_DECLARATOR]
        AST_DA_ARRAY,            // [AST_EXPRESSION ?, AST_QU_TYPE *]
        AST_DA_STATIC_ARRAY,     // [AST_EXPRESSION, AST_QU_TYPE *]
        AST_DA_STAR_ARRAY,       // []
        AST_DA_FUNCTION,         // [AST_PARAMETER_DECLARATION *]
        AST_DA_VA_ARG_FUNCTION,  // [AST_PARAMETER_DECLARATION +]

    AST_INITIALIZER,

        AST_IN_EXPRESSION,       // [AST_EXPRESSION]
        AST_IN_INITIALIZER_LIST, // [AST_INITIALIZER_ITEM +]

    AST_INITIALIZER_ITEM,        // [AST_INITIALIZER, AST_DESIGNATOR *]
    AST_DESIGNATOR,

        AST_DE_ARRAY_SUBSCRIPT,  // [AST_EXPRESSION]
        AST_DE_MEMBER,           // [AST_IDENTIFIER]
};

enum ast_statement {

    AST_STATEMENT = 30000,

        AST_ST_LABEL,            // [AST_IDENTIFIER, AST_STATEMENT]
        AST_ST_CASE,             // [AST_EXPRESSION, AST_STATEMENT]
        AST_ST_DEFAULT,          // [AST_STATEMENT]
        AST_ST_COMPOUNT_STATEMENT, // [AST_BLOCK_ITEM *]
        AST_ST_EXPRESSION,       // [AST_EXPRESSION ?]
        AST_ST_IF,               // [AST_EXPRESSION, AST_STATEMENT]
        AST_ST_IF_ELSE,          // [AST_EXPRESSION, AST_STATEMENT, AST_STATEMENT]
        AST_ST_SWITCH,           // [AST_EXPRESSION, AST_STATEMENT]
        AST_ST_WHILE,            // [AST_EXPRESSION, AST_STATEMENT]
        AST_ST_DO_WHILE,         // [AST_STATEMENT, AST_EXPRESSION]
        AST_ST_FOR,              // [AST_EXPRESSION ?, AST_EXPRESSION ?, AST_EXPRESSION ?, AST_STATEMENT]
        AST_ST_FOR_DECL,         // [AST_DECLARATION, AST_EXPRESSION ?, AST_EXPRESSION ?, AST_STATEMENT]
        AST_ST_GOTO,             // [AST_IDENTIFIER]
        AST_ST_CONTINUE,         // []
        AST_ST_BREAK,            // []
        AST_ST_RETURN,           // [AST_EXPRESSION ?]

    AST_BLOCK_ITEM,

        AST_BL_DECLARATION,      // [AST_DECLARATION]
        AST_BL_STATEMENT,        // [AST_STATEMENT]
};

enum ast_external_definition {

    AST_TRANSLATION_UNIT,        // [AST_EXTERNAL_DECLARATION +]
    AST_EXTERNAL_DECLARATION,

        AST_ED_DECLARATION,      // [AST_DECLARATION]
        AST_ED_FUNCTION,         // [AST_FUNCTION_DEFINITION]

    AST_FUNCTION_DEFINITION,     // [AST_DECLARATION_SPECIFIER_LIST, AST_DECLARATOR, AST_STATEMENT, AST_DECLARATION *]
};

/**
 * @brief Create a new AST node.
 * @returns a pointer to the new node.
 */
struct ast_node* ast_new_node(void);

/**
 * @brief Delete an AST subtree.
 * @param node - Root node.
 */
void ast_delete_node(struct ast_node *node);


/**
 * @brief Add a child to the front of the child list of an AST node.
 * @param node - Parent node.
 * @param child - Child node.
 */
void ast_push_child_front(struct ast_node *node, struct ast_node *child);

/**
 * @brief Add a child to the back of the child list of an AST node.
 * @param node - Parent node.
 * @param child - Child node.
 */
void ast_push_child_back(struct ast_node *node, struct ast_node *child);

/**
 * @brief Get a specific child of an AST node.
 * @param node - Parent node.
 * @param pos - Position in the child list (0-based).
 * @returns the child node.
 */
struct ast_node* ast_get_child(struct ast_node *node, int pos);

/**
 * @brief Add a child to a specific position of the child list of an AST node.
 * @param node - Parent node.
 * @param pos - Position in the child list (0-based).
 * @param child - Child node.
 */
void ast_set_child(struct ast_node *node, int pos, struct ast_node *child);

/**
 * @brief Set text bounds for a compound AST node.
 * @param node - Target node.
 * @param first - First child.
 * @param last - Last child.
 */
void ast_set_text_bounds(struct ast_node *node, struct ast_node *first, struct ast_node *last);


#endif /* __AST_H__ */
