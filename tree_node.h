#ifndef __TREE_NODE_H__
#define __TREE_NODE_H__


struct tree_node {

    char *text;
    int text_length;

    int text_line_from;
    int text_line_to;
    int text_column_from;
    int text_column_to;

    int node_type;
    int node_subtype;

    int data_type;

    int child_count;

    struct tree_node *parent;
    struct tree_node *first_child;
    struct tree_node *last_child;
    struct tree_node *prev_sibling;
    struct tree_node *next_sibling;

    struct tree_node *prev_token;
    struct tree_node *next_token;
};


enum node_type {

/* anonymous node (empty or list node) */

    NODE_NONE,

/* tokens (leaf nodes) */

    NODE_WHITESPACE,

    NODE_IDENTIFIER,

    NODE_TYPEDEF_NAME,

    NODE_STRING_LITERAL,

    NODE_CONSTANT,

        NODE_CN_INTEGER,
        NODE_CN_FLOATING,
        NODE_CN_CHARACTER,

    NODE_KEYWORD,

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

    NODE_PUNCTUATOR,

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
        NODE_PT_COND        = '?',
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

    NODE_EXPRESSION,

        NODE_EX_CONSTANT,
        /* ( NODE_CONSTANT ) */
        NODE_EX_IDENTIFIER,
        /* ( NODE_IDENTIFIER ) */
        NODE_EX_STRING_LITERAL,
        /* ( NODE_STRING_LITERAL ) */
        NODE_EX_EXPRESSION,
        /* ( NODE_EX_EXPRESSION ) */
        NODE_EX_ARRAY_SUBSCRIPTING,
        /* ( NODE_EXPRESSION , NODE_EXPRESSION )  */
        NODE_EX_FUNCTION_CALL,
        /* ( NODE_EXPRESSION , NODE_EXPRESSION... ) */
        NODE_EX_MEMBER,
        /* ( NODE_EXPRESSION , NODE_IDENTIFIER ) */
        NODE_EX_COMPOUND_LITERAL,
        /* ( NODE_TYPE_NAME , NODE_INITIALIZER... ) */
        NODE_EX_SIZEOF_EXPRESSION,
        /* ( NODE_EXPRESSION ) */
        NODE_EX_SIZEOF_TYPE_NAME,
        /* ( NODE_TYPE_NAME ) */
        NODE_EX_UNARY_PREFIX,
        /* ( NODE_PUNCTUATOR , NODE_EXPRESSION ) */
        NODE_EX_UNARY_POSTFIX,
        /* ( NODE_EXPRESSION , NODE_PUNCTUATOR ) */
        NODE_EX_CAST,
        /* ( NODE_TYPE_NAME , NODE_EXPRESSION ) */
        NODE_EX_MULTIPLICATIVE,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_ADDITIVE,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_SHIFT,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_RELATIONAL,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_EQUALITY,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_AND,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_EXCLUSIVE_OR,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_INCLUSIVE_OR,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_LOGICAL_AND,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_LOGICAL_OR,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_CONDITIONAL,
        /* ( NODE_EXPRESSION, NODE_EXPRESSION, NODE_EXPRESSION ) */
        NODE_EX_ASSIGNMENT,
        /* ( NODE_EXPRESSION, NODE_PUNCTUATOR, NODE_EXPRESSION ) */
        NODE_EX_COMMA,
        /* ( NODE_EXPRESSION, NODE_EXPRESSION ) */

/* declarations (internal nodes) */

    NODE_DECLARATION,
    /* ( NODE_DECLARATION_SPECIFIER_LIST, NODE_INIT_DECLARATOR... ) */

    NODE_DECLARATION_SPECIFIER_LIST,
    /* ( NODE_DECLARATION_SPECIFIER , NODE_DECLARATION_SPECIFIER... ) */

    NODE_DECLARATION_SPECIFIER,

        NODE_SP_STORAGE_CLASS,
        /* ( NODE_KEYWORD ) */
        NODE_SP_TYPE,
        /* ( NODE_KEYWORD | NODE_TYPEDEF_NAME | NODE_STRUCT_OR_UNION_SPECIFIER | NODE_ENUM_SPECIFIER ) */
        NODE_QU_TYPE,
        /* ( NODE_KEYWORD ) */
        NODE_SP_FUNCTION,
        /* ( NODE_KEYWORD ) */

    NODE_INIT_DECLARATOR,

        NODE_IN_DECLARATOR,
        /* ( NODE_DECLARATOR ) */
        NODE_IN_INITIALIZER,
        /* ( NODE_DECLARATOR , NODE_INITIALIZER ) */

    NODE_STRUCT_OR_UNION_SPECIFIER,

        NODE_ST_UN_DECLARATION,
        /* ( NODE_KEYWORD, NODE_IDENTIFIER ) */
        NODE_ST_UN_DEFINITION,
        /* ( NODE_KEYWORD, NODE_IDENTIFIER, NODE_STRUCT_DECLARATION, NODE_STRUCT_DECLARATION... ) */
        NODE_ST_UN_ANONYMOUS_DEFINITION,
        /* ( NODE_KEYWORD, NODE_STRUCT_DECLARATION, NODE_STRUCT_DECLARATION... ) */

    NODE_STRUCT_DECLARATION,
    /* ( NODE_SPECIFIER_QUALIFIER_LIST, NODE_STRUCT_DECLARATOR, NODE_STRUCT_DECLARATOR... ) */

    NODE_SPECIFIER_QUALIFIER_LIST,
    /* ( ( NODE_SP_TYPE | NODE_QU_TYPE )... ) */

    NODE_STRUCT_DECLARATOR,

        NODE_ST_DECLARATOR,
        /* ( NODE_DECLARATOR ) */
        NODE_ST_BITFIELD,
        /* ( NODE_DECLARATOR , NODE_EXPRESSION ) */
        NODE_ST_ANONYMOUS_BITFIELD,
        /* ( NODE_EXPRESSION ) */

    NODE_ENUM_SPECIFIER,

        NODE_EN_DECLARATION,
        /* ( NODE_IDENTIFIER ) */
        NODE_EN_DEFINITION,
        /* ( NODE_IDENTIFIER , NODE_ENUMERATOR, NODE_ENUMERATOR... ) */
        NODE_EN_ANONYMOUS_DEFINITION,
        /* ( NODE_ENUMERATOR, NODE_ENUMERATOR... ) */

    NODE_ENUMERATOR,

        NODE_EN_AUTOMATIC,
        /* ( NODE_IDENTIFIER ) */
        NODE_EN_INITIALIZED,
        /* ( NODE_IDENTIFIER , NODE_EXPRESSION ) */

    NODE_DECLARATOR,

        NODE_DE_DIRECT,
        /* ( NODE_DIRECT_DECLARATOR , NODE_DIRECT_DECLARATOR... ) */
        NODE_DE_POINTER,
        /* ( NODE_POINTER , NODE_DIRECT_DECLARATOR , NODE_DIRECT_DECLARATOR... ) */

    NODE_DIRECT_DECLARATOR,

        NODE_DD_IDENTIFIER,
        /* ( NODE_IDENTIFIER ) */
        NODE_DD_DECLARATOR,
        /* ( NODE_DECLARATOR ) */
        NODE_DD_AUTOMATIC_ARRAY
        /* ( NODE_QU_TYPE... ) */
        NODE_DD_ARRAY,
        /* ( NODE_EXPRESSION , NODE_QU_TYPE... ) */
        NODE_DD_STATIC_ARRAY,
        /* ( NODE_EXPRESSION , NODE_QU_TYPE... ) */
        NODE_DD_STAR_ARRAY,
        /* ( NODE_QU_TYPE... ) */
        NODE_DD_FUNCTION,
        /* ( NODE_PARAMETER_DECLARATION , NODE_PARAMETER_DECLARATION... ) */
        NODE_DD_VA_ARG_FUNCTION,
        /* ( NODE_PARAMETER_DECLARATION , NODE_PARAMETER_DECLARATION... ) */
        NODE_DD_OLD_FUNCTION,
        /* ( NODE_IDENTIFIER... ) */

    NODE_PARAMETER_DECLARATION,

        NODE_PA_ANONYMOUS_DECLARATION,
        /* ( NODE_DECLARATION_SPECIFIER_LIST ) */
        NODE_PA_DECLARATION,
        /* ( NODE_DECLARATION_SPECIFIER_LIST , NODE_DECLARATOR ) */
        NODE_PA_ABSTRACT_DECLARATION,
        /* ( NODE_DECLARATION_SPECIFIER_LIST , NODE_ABSTRACT_DECLARATOR ) */

    NODE_TYPE_NAME,

        NODE_TN_QUALIFIERS,
        /* ( NODE_SPECIFIER_QUALIFIER_LIST ) */
        NODE_TN_DECLARATOR,
        /* ( NODE_SPECIFIER_QUALIFIER_LIST , NODE_ABSTRACT_DECLARATOR ) */

    NODE_ABSTRACT_DECLARATOR,

        NODE_AB_DIRECT,
        /* ( NODE_DIRECT_ABSTRACT_DECLARATOR , NODE_DIRECT_ABSTRACT_DECLARATOR... ) */
        NODE_AB_POINTER,
        /* ( NODE_POINTER, NODE_DIRECT_ABSTRACT_DECLARATOR... ) */

    NODE_DIRECT_ABSTRACT_DECLARATOR,

        NODE_DA_DECLARATOR,
        /* ( NODE_ABSTRACT_DECLARATOR ) */
        NODE_DA_AUTOMATIC_ARRAY
        /* ( NODE_QU_TYPE...) */
        NODE_DA_ARRAY,
        /* ( NODE_EXPRESSION , NODE_QU_TYPE... ) */
        NODE_DA_STATIC_ARRAY,
        /* ( NODE_EXPRESSION , NODE_QU_TYPE... ) */
        NODE_DA_STAR_ARRAY,
        /* ( ) */
        NODE_DA_FUNCTION,
        /* ( NODE_PARAMETER_DECLARATION... ) */
        NODE_DA_VA_ARG_FUNCTION,
        /* ( NODE_PARAMETER_DECLARATION , NODE_PARAMETER_DECLARATION... ) */

    NODE_INITIALIZER,

        NODE_IN_EXPRESSION,
        /* ( NODE_EXPRESSION ) */
        NODE_IN_INITIALIZER_LIST,
        /* ( NODE_INITIALIZER_ITEM , NODE_INITIALIZER_ITEM... ) */

    NODE_INITIALIZER_ITEM,
    /* ( NODE_INITIALIZER , NODE_DESIGNATOR... ) */

    NODE_DESIGNATOR,

        NODE_DE_ARRAY_SUBSCRIPT,
        /* ( NODE_EXPRESSION ) */
        NODE_DE_MEMBER,
        /* ( NODE_IDENTIFIER ) */

/* statements (internal nodes) */

    /* TODO */

/* external definitions (internat/root nodes) */

    /* TODO */

};


#endif /* __TREE_NODE_H__ */

