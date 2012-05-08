#ifndef __AST_NODE_H__
#define __AST_NODE_H__


struct ast_node {

    int buffer_offset;
    int text_length;

    int text_line_from;
    int text_line_to;
    int text_column_from;
    int text_column_to;

    int node_type;
    int node_subtype;

    int data_type;

    struct ast_node *parent;
    struct ast_node *first_son;
    struct ast_node *last_son;
    struct ast_node *prev_sibling;
    struct ast_node *next_sibling;

    union {
        void * data;
    } data;
};


enum node_type {

/* tokens (leaf nodes) */

    NODE_IDENTIFIER,
    NODE_STRING_LITERAL,
    NODE_CONSTANT,
    NODE_KEYWORD,
    NODE_PUNCTUATOR,

    /* keyword node subtypes */

    NODE_KW_AUTO        = AUTO,
    NODE_KW_BREAK       = BREAK,
    NODE_KW_CASE        = CASE,
    NODE_KW_CHAR        = CHAR,
    NODE_KW_CONST       = CONST,
    NODE_KW_CONTINUE    = CONTINUE,
    NODE_KW_DEFAUT      = DEFAUT,
    NODE_KW_DO          = DO,
    NODE_KW_DOUBLE      = DOUBLE,
    NODE_KW_ELSE        = ELSE,
    NODE_KW_ENUM        = ENUM,
    NODE_KW_EXTERN      = EXTERN,
    NODE_KW_FLOAT       = FLOAT,
    NODE_KW_FOR         = FOR,
    NODE_KW_GOTO        = GOTO,
    NODE_KW_IF          = IF,
    NODE_KW_INLINE      = INLINE,
    NODE_KW_INT         = INT,
    NODE_KW_LONG        = LONG,
    NODE_KW_REGISTER    = REGISTER,
    NODE_KW_RESTRICT    = RESTRICT,
    NODE_KW_RETURN      = RETURN,
    NODE_KW_SHORT       = SHORT,
    NODE_KW_SIGNED      = SIGNED,
    NODE_KW_SIZEOF      = SIZEOF,
    NODE_KW_STATIC      = STATIC,
    NODE_KW_STRUCT      = STRUCT,
    NODE_KW_SWITCH      = SWITCH,
    NODE_KW_TYPEDEF     = TYPEDEF,
    NODE_KW_UNION       = UNION,
    NODE_KW_UNSIGNED    = UNSIGNED,
    NODE_KW_VOID        = VOID,
    NODE_KW_VOLATILE    = VOLATILE,
    NODE_KW_WHILE       = WHILE,
    NODE_KW__BOOL       = _BOOL,
    NODE_KW__COMPLEX    = _COMPLEX,
    NODE_KW__IMAGINARY  = _IMAGINARY,

    /* punctuator node subtypes */

    NODE_PT_RSQ_BRACKET = '[',
    NODE_PT_LSQ_BRAQUET = ']',
    NODE_PT_RRD_BRACKET = '(',
    NODE_PT_LRD_BRACKET = ')',
    NODE_PT_RCU_BRACKET = '{',
    NODE_PT_LCU_BRACKET = '|',
    NODE_PT_MEMBER      = '.',
    NODE_PT_AND         = '&',
    NODE_PT_MUL         = '*',
    NODE_PT_ADD         = '+',
    NODE_PT_SUB         = '-',
    NODE_PT_COMMA       = ',',
    NODE_PT_HASH        = '#',
    NODE_PT_COMPL       = '~',
    NODE_PT_NOT         = '!',
    NODE_PT_DIV         = '/',
    NODE_PT_MOD         = '%',
    NODE_PT_LESS        = '<',
    NODE_PT_MORE        = '>',
    NODE_PT_XOR         = '^',
    NODE_PT_OR          = '|',
    NODE_PT_TERNARY     = '?',
    NODE_PT_COLON       = ':',
    NODE_PT_SEMICOLON   = ';',
    NODE_PT_ASSIGN      = '=',
	NODE_PT_LOGICAL_AND = LOGICAL_AND,
	NODE_PT_LOGICAL_OR 	= LOGICAL_OR,
	NODE_PT_ELLIPSIS 	= ELLIPSIS,
	NODE_PT_MUL_ASSIGN 	= MUL_ASSIGN,
	NODE_PT_DIV_ASSIGN 	= DIV_ASSIGN,
	NODE_PT_MOD_ASSIGN 	= MOD_ASSIGN,
	NODE_PT_ADD_ASSIGN 	= ADD_ASSIGN,
	NODE_PT_SUB_ASSIGN 	= SUB_ASSIGN,
	NODE_PT_LESS_EQUAL 	= LESS_EQUAL,
	NODE_PT_MORE_EQUAL 	= MORE_EQUAL,
	NODE_PT_EQUAL 	    = EQUAL,
	NODE_PT_NOT_EQUAL   = NOT_EQUAL,
	NODE_PT_LSHIFT_ASSIGN = LSHIFT_ASSIGN,
	NODE_PT_RSHIFT_ASSIGN = RSHIFT_ASSIGN,
	NODE_PT_AND_ASSIGN 	= AND_ASSIGN,
	NODE_PT_XOR_ASSIGN 	= XOR_ASSIGN,
	NODE_PT_OR_ASSIGN 	= OR_ASSIGN,
	NODE_PT_PASTE 	    = PASTE,
	NODE_PT_POINTER 	= POINTER,
	NODE_PT_INC         = INCREMENT,
	NODE_PT_DEC     	= DECREMENT,
	NODE_PT_LSHIFT 	    = LSHIFT,
	NODE_PT_RSHIFT 	    = RSHIFT,

/* expressions (internal nodes) */

    UNARY_OPERATOR,
    BINARY_OPERATOR,
    /* TODO */

    NODE_PRIMARY_EXPRESSION,
    POSTFIX_EXPRESSION,
    ARGUMENT_EXPRESSION,
    UNARY_EXPRESSION,
    UNARY_OPERATOR,
    CAST_EXPRESSION,
    MULTIPLICATIVE_EXPRESSION,
    ADDITIVE_EXPRESSION,
    SHIFT_EXPRESSION,
    RELATIONAL_EXPRESSION,
    EQUALITY_EXPRESSION,
    AND_EXPRESSION,
    EXCLUSIVE_OR_EXPRESSION,
    INCLUSIVE_OR_EXPRESSION,
    LOGICAL_AND_EXPRESSION,
    LOGICAL_OR_EXPRESSION,
    CONDITIONAL_EXPRESSION,
    ASSIGNMENT_EXPRESSION,
    ASSIGNMENT_OPERATOR,
    EXPRESSION,
    CONSTANT_EXPRESSION,

/* declarations (internal nodes) */

    /* TODO */

/* statements (internal nodes) */

    /* TODO */

/* external definitions (internat/root nodes) */

    /* TODO */

};


#endif /* __AST_NODE_H__ */

