%{

#include "tree_terminals.h"

%}

%union {

    struct keyword        keyword;
    struct punctuator     punctuator;
    struct identifier     identifier;
    struct string_literal string_literal;
    struct constant       constant;
}

%token <identifier> IDENTIFIER TYPE_NAME
%token <string_literal> STRING_LITERAL
%token <constant> CONSTANT

%token <keyword> AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM
%token <keyword> EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT
%token <keyword> RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION
%token <keyword> UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY

%token <punctuator> '[' ']' '(' ')' '{' '}' '.' '&' '*' '+' '-' ',' '#' '~' '!'
%token <punctuator> '/' '%' '<' '>' '^' '|' '?' ':' ';' '='

%token <punctuator> AND OR ELLIPSIS MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token <punctuator> SUB_ASSIGN LESS_EQUAL MORE_EQUAL EQUAL NOT_EQUAL
%token <punctuator> LSHIFT_ASSIGN RSHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token <punctuator> PASTE POINTER INCREMENT DECREMENT LSHIFT RSHIFT

%token PARSE_ERROR

%start translation_unit

%%

primary_expression
    : IDENTIFIER
    | CONSTANT
    | STRING_LITERAL
    | '(' expression ')'
    ;

postfix_expression
    : primary_expression
    | postfix_expression '[' expression ']'
    | postfix_expression '(' argument_expression_list ')'
    | postfix_expression '(' ')'
    | postfix_expression '.' IDENTIFIER
    | postfix_expression POINTER IDENTIFIER
    | postfix_expression INCREMENT
    | postfix_expression DECREMENT
    | '(' type_name ')' '{' initializer_list '}'
    | '(' type_name ')' '{' initializer_list ',' '}'
    ;

argument_expression_list
    : assignment_expression
    | argument_expression_list ',' assignment_expression
    ;

unary_expression
    : postfix_expression
    | INCREMENT unary_expression
    | DECREMENT unary_expression
    | unary_operator cast_expression
    | SIZEOF unary_expression
    | SIZEOF '(' type_name ')'
    ;

unary_operator
    : '&'
    | '*'
    | '+'
    | '-'
    | '~'
    | '!'
    ;

cast_expression
    : unary_expression
    | '(' type_name ')' cast_expression
    ;

multiplicative_expression
    : cast_expression
    | multiplicative_expression '*' cast_expression
    | multiplicative_expression '/' cast_expression
    | multiplicative_expression '%' cast_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression
    | additive_expression '-' multiplicative_expression
    ;

shift_expression
    : additive_expression
    | shift_expression LSHIFT additive_expression
    | shift_expression RSHIFT additive_expression
    ;

relational_expression
    : shift_expression
    | relational_expression '<' shift_expression
    | relational_expression '>' shift_expression
    | relational_expression LESS_EQUAL shift_expression
    | relational_expression MORE_EQUAL shift_expression
    ;

equality_expression
    : relational_expression
    | equality_expression EQUAL relational_expression
    | equality_expression NOT_EQUAL relational_expression
    ;

AND_expression
    : equality_expression
    | AND_expression '&' equality_expression
    ;

exclusive_OR_expression
    : AND_expression
    | exclusive_OR_expression '^' AND_expression
    ;

inclusive_OR_expression
    : exclusive_OR_expression
    | inclusive_OR_expression '|' exclusive_OR_expression
    ;

logical_AND_expression
    : inclusive_OR_expression
    | logical_AND_expression AND inclusive_OR_expression
    ;

logical_OR_expression
    : logical_AND_expression
    | logical_OR_expression OR logical_AND_expression
    ;

conditional_expression
    : logical_OR_expression
    | logical_OR_expression '?' expression ':' conditional_expression
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression
    ;

assignment_operator
    : '='
    | MUL_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN
    | ADD_ASSIGN
    | SUB_ASSIGN
    | LSHIFT_ASSIGN
    | RSHIFT_ASSIGN
    | AND_ASSIGN
    | XOR_ASSIGN
    | OR_ASSIGN
    ;

expression
    : assignment_expression
    | expression ',' assignment_expression
    ;

constant_expression
    : conditional_expression
    ;

declaration
    : declaration_specifiers init_declarator_list ';'
    | declaration_specifiers ';'
    ;

declaration_specifiers
    : storage_class_specifier declaration_specifiers
    | storage_class_specifier
    | type_specifier declaration_specifiers
    | type_specifier
    | type_qualifier declaration_specifiers
    | type_qualifier
    | function_specifier declaration_specifiers
    | function_specifier
    ;

init_declarator_list
    : init_declarator
    | init_declarator_list ',' init_declarator
    ;

init_declarator
    : declarator
    | declarator '=' initializer
    ;

storage_class_specifier
    : TYPEDEF
    | EXTERN
    | STATIC
    | AUTO
    | REGISTER
    ;

type_specifier
    : VOID
    | CHAR
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    | SIGNED
    | UNSIGNED
    | _BOOL
    | _COMPLEX
    | struct_or_union_specifier
    | enum_specifier
    | typedef_name
    ;

struct_or_union_specifier
    : struct_or_union IDENTIFIER '{' struct_declaration_list '}'
    | struct_or_union '{' struct_declaration_list '}'
    | struct_or_union IDENTIFIER
    ;

struct_or_union
    : STRUCT
    | UNION
    ;

struct_declaration_list
    : struct_declaration
    | struct_declaration_list struct_declaration
    ;

struct_declaration
    : specifier_qualifier_list struct_declarator_list ';'
    ;

specifier_qualifier_list
    : type_specifier specifier_qualifier_list
    | type_specifier
    | type_qualifier specifier_qualifier_list
    | type_qualifier
    ;

struct_declarator_list
    : struct_declarator
    | struct_declarator_list ',' struct_declarator
    ;

struct_declarator
    : declarator
    | declarator ':' constant_expression
    | ':' constant_expression
    ;

enum_specifier
    : ENUM IDENTIFIER '{' enumerator_list '}'
    | ENUM '{' enumerator_list '}'
    | ENUM IDENTIFIER '{' enumerator_list ',' '}'
    | ENUM '{' enumerator_list ',' '}'
    | ENUM IDENTIFIER
    ;

enumerator_list
    : enumerator
    | enumerator_list ',' enumerator
    ;

enumerator
    : IDENTIFIER
    | IDENTIFIER '=' constant_expression
    ;

type_qualifier
    : CONST
    | RESTRICT
    | VOLATILE
    ;

function_specifier
    : INLINE
    ;

declarator
    : pointer direct_declarator
    | direct_declarator
    ;

direct_declarator
    : IDENTIFIER
    | '(' declarator ')'
    | direct_declarator '[' type_qualifier_list assignment_expression ']'
    | direct_declarator '[' type_qualifier_list ']'
    | direct_declarator '[' assignment_expression ']'
    | direct_declarator '[' ']'
    | direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
    | direct_declarator '[' STATIC assignment_expression ']'
    | direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
    | direct_declarator '[' type_qualifier_list '*' ']'
    | direct_declarator '[' '*' ']'
    | direct_declarator '(' parameter_type_list ')'
    | direct_declarator '(' identifier_list ')'
    | direct_declarator '(' ')'
    ;

pointer
    : '*' type_qualifier_list
    | '*'
    | '*' type_qualifier_list pointer
    | '*' pointer
    ;

type_qualifier_list
    : type_qualifier
    | type_qualifier_list type_qualifier
    ;

parameter_type_list
    : parameter_list
    | parameter_list ',' ELLIPSIS
    ;

parameter_list
    : parameter_declaration
    | parameter_list ',' parameter_declaration
    ;

parameter_declaration
    : declaration_specifiers declarator
    | declaration_specifiers abstract_declarator
    | declaration_specifiers
    ;

identifier_list
    : IDENTIFIER
    | identifier_list ',' IDENTIFIER
    ;

type_name
    : specifier_qualifier_list abstract_declarator
    | specifier_qualifier_list
    ;

abstract_declarator
    : pointer
    | pointer direct_abstract_declarator
    | direct_abstract_declarator
    ;

direct_abstract_declarator
    : '(' abstract_declarator ')'
    | direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'
    | '[' type_qualifier_list assignment_expression ']'
    | direct_abstract_declarator '[' assignment_expression ']'
    | direct_abstract_declarator '[' type_qualifier_list ']'
    | direct_abstract_declarator '[' ']'
    | '[' type_qualifier_list ']'
    | '[' assignment_expression ']'
    | '[' ']'
    | direct_abstract_declarator '[' STATIC type_qualifier_list assignment_expression ']'
    | '[' STATIC type_qualifier_list assignment_expression ']'
    | direct_abstract_declarator '[' STATIC assignment_expression ']'
    | '[' STATIC assignment_expression ']'
    | direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'
    | '[' type_qualifier_list STATIC assignment_expression ']'
    | direct_abstract_declarator '[' '*' ']'
    | '[' '*' ']'
    | direct_abstract_declarator '(' parameter_type_list ')'
    | '(' parameter_type_list ')'
    | direct_abstract_declarator '(' ')'
    | '(' ')'
    ;

typedef_name
/*  : IDENTIFIER */
    : TYPE_NAME
    ;

initializer
    : assignment_expression
    | '{' initializer_list '}'
    | '{' initializer_list ',' '}'
    ;

initializer_list
    : designation initializer
    | initializer
    | initializer_list ',' designation initializer
    | initializer_list ',' initializer
    ;

designation
    : designator_list '='
    ;

designator_list
    : designator
    | designator_list designator
    ;

designator
    : '[' constant_expression ']'
    | '.' IDENTIFIER
    ;

statement
    : labeled_statement
    | compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;

labeled_statement
    : IDENTIFIER ':' statement
    | CASE constant_expression ':' statement
    | DEFAULT ':' statement
    ;

compound_statement
    : '{' block_item_list '}'
    | '{' '}'
    ;

block_item_list
    : block_item
    | block_item_list block_item
    ;

block_item
    : declaration
    | statement
    ;

expression_statement
    : expression ';'
    | ';'
    ;

selection_statement
    : IF '(' expression ')' statement
    | IF '(' expression ')' statement ELSE statement
    | SWITCH '(' expression ')' statement
    ;

iteration_statement
    : WHILE '(' expression ')' statement
    | DO statement WHILE '(' expression ')' ';'
    | FOR '(' expression_statement expression_statement expression ')' statement
    | FOR '(' expression_statement expression_statement ')' statement
    | FOR '(' declaration expression_statement expression ')' statement
    | FOR '(' declaration expression_statement ')' statement
    ;

jump_statement
    : GOTO IDENTIFIER ';'
    | CONTINUE ';'
    | BREAK ';'
    | RETURN expression ';'
    | RETURN ';'
    ;

translation_unit
    : external_declaration
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement
    | declaration_specifiers declarator compound_statement
    ;

declaration_list
    : declaration
    | declaration_list declaration
    ;

%%

// TODO

