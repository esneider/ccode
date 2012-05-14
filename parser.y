%{

#define YYSTYPE struct tree_node*

#include <stdlib.h>
#include "tree_node.h"

%}

%token IDENTIFIER
%token TYPE_NAME
%token STRING_LITERAL
%token CONSTANT

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM
%token EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT
%token RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION
%token UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY

%token LOGICAL_AND LOGICAL_OR ELLIPSIS MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LESS_EQUAL MORE_EQUAL EQUAL NOT_EQUAL
%token LSHIFT_ASSIGN RSHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token PASTE POINTER INCREMENT DECREMENT LSHIFT RSHIFT

%expect 1

%start translation_unit

%%

primary_expression
    : IDENTIFIER {

            $$ = $1;
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_IDENTIFIER;
        }
    | CONSTANT {

            $$ = $1;
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_CONSTANT;
        }
    | STRING_LITERAL {

            $$ = $1;
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_STRING_LITERAL;
        }
    | '(' expression ')' {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $2 );
            tree_node_set_text_bounds( $$, $1, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_EXPRESSION;
        }
    ;

postfix_expression
    : primary_expression
    | postfix_expression '[' expression ']' {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $3 );
            tree_node_set_text_bounds( $$, NULL, $4 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_ARRAY_SUBSCRIPTING;
        }
    | postfix_expression '(' argument_expression_list ')' {

            $$ = $3;
            tree_node_push_front( $$, $1 );
            tree_node_set_text_bounds( $$, NULL, $4 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_FUNCTION_CALL;
        }
    | postfix_expression '(' ')' {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_text_bounds( $$, NULL, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_FUNCTION_CALL;
        }
    | postfix_expression '.' IDENTIFIER {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_MEMBER;
        }
    | postfix_expression POINTER IDENTIFIER {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_POINTER_MEMBER;
        }
    | postfix_expression INCREMENT {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_UNARY_POSTFIX;
        }
    | postfix_expression DECREMENT {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_UNARY_POSTFIX;
        }
    | '(' type_name ')' '{' initializer_list '}' {

            $$ = $5;
            tree_node_push_front( $$, $2 );
            tree_node_set_text_bounds( $$, $1, $6 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_COMPOUND_LITERAL;
        }
    | '(' type_name ')' '{' initializer_list ',' '}' {

            $$ = $5;
            tree_node_push_front( $$, $2 );
            tree_node_set_text_bounds( $$, $1, $7 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_COMPOUND_LITERAL;
        }

    ;

argument_expression_list
    : assignment_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
        }
    | argument_expression_list ',' assignment_expression {

            tree_node_push_back( $$, $3 );
        }
    ;

unary_expression
    : postfix_expression
    | INCREMENT unary_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_UNARY_PREFIX;
        }
    | DECREMENT unary_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_UNARY_PREFIX;
        }
    | unary_operator cast_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_UNARY_PREFIX;
        }
    | SIZEOF unary_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $2 );
            tree_node_set_text_bounds( $$, $1, NULL );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_SIZEOF_EXPRESSION;
        }
    | SIZEOF '(' type_name ')' {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $2 );
            tree_node_set_text_bounds( $$, $1, NULL );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_SIZEOF_TYPE_NAME;
        }
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
    | '(' type_name ')' cast_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $2 );
            tree_node_set_child( $$, 1, $4 );
            tree_node_set_text_bounds( $$, $1, NULL );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_CAST;
        }
    ;

multiplicative_expression
    : cast_expression
    | multiplicative_expression '*' cast_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | multiplicative_expression '/' cast_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | multiplicative_expression '%' cast_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | additive_expression '-' multiplicative_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

shift_expression
    : additive_expression
    | shift_expression LSHIFT additive_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | shift_expression RSHIFT additive_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

relational_expression
    : shift_expression
    | relational_expression '<' shift_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | relational_expression '>' shift_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | relational_expression LESS_EQUAL shift_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | relational_expression MORE_EQUAL shift_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

equality_expression
    : relational_expression
    | equality_expression EQUAL relational_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    | equality_expression NOT_EQUAL relational_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

AND_expression
    : equality_expression
    | AND_expression '&' equality_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

exclusive_OR_expression
    : AND_expression
    | exclusive_OR_expression '^' AND_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

inclusive_OR_expression
    : exclusive_OR_expression
    | inclusive_OR_expression '|' exclusive_OR_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

logical_AND_expression
    : inclusive_OR_expression
    | logical_AND_expression LOGICAL_AND inclusive_OR_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

logical_OR_expression
    : logical_AND_expression
    | logical_OR_expression LOGICAL_OR logical_AND_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_BINARY;
        }
    ;

conditional_expression
    : logical_OR_expression
    | logical_OR_expression '?' expression ':' conditional_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $3 );
            tree_node_set_child( $$, 2, $5 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_CONDITIONAL;
        }
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            tree_node_set_child( $$, 2, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_ASSIGNMENT;
        }
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
    | expression ',' assignment_expression {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $3 );
            $$->node_type = NODE_EXPRESSION;
            $$->node_subtype = NODE_EX_COMMA;
        }
    ;

constant_expression
    : conditional_expression
    ;

declaration
    : declaration_specifiers init_declarator_list ';' {

            $$ = $2;
            tree_node_push_front( $$, $1 );
            tree_node_set_text_bounds( $$, NULL, $3 );
            $$->node_type = NODE_DECLARATION;
        }
    | declaration_specifiers ';' {

            $$ = $1;
            tree_node_set_text_bounds( $$, NULL, $2 );
            $$->node_type = NODE_DECLARATION;
        }
    ;

declaration_specifiers
    : declaration_specifiers storage_class_specifier {

            tree_node_push_back( $$, $2 );
        }
    | storage_class_specifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER_LIST;
        }
    | declaration_specifiers type_specifier {

            tree_node_push_back( $$, $2 );
        }
    | type_specifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER_LIST;
        }
    | declaration_specifiers type_qualifier {

            tree_node_push_back( $$, $2 );
        }
    | type_qualifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER_LIST;
        }
    | declaration_specifiers function_specifier {

            tree_node_push_back( $$, $2 );
        }
    | function_specifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER_LIST;
        }
    ;

init_declarator_list
    : init_declarator {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
        }
    | init_declarator_list ',' init_declarator {

            tree_node_push_back( $$, $3 );
        }
    ;

init_declarator
    : declarator {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, new_tree_node() ); /* necessary? */
            $$->node_type = NODE_INIT_DECLARATOR;
        }
    | declarator '=' initializer {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_INIT_DECLARATOR;
        }
    ;

storage_class_specifier
    : TYPEDEF {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_STORAGE_CLASS;
        }
    | EXTERN {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_STORAGE_CLASS;
        }
    | STATIC {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_STORAGE_CLASS;
        }
    | AUTO {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_STORAGE_CLASS;
        }
    | REGISTER {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_STORAGE_CLASS;
        }
    ;

type_specifier
    : VOID {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | CHAR {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | SHORT {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | INT {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | LONG {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | FLOAT {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | DOUBLE {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | SIGNED {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | UNSIGNED {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | _BOOL {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | _COMPLEX {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | struct_or_union_specifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | enum_specifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    | typedef_name {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER;
            $$->node_subtype = NODE_SP_TYPE;
        }
    ;

struct_or_union_specifier
    : struct_or_union IDENTIFIER '{' struct_declaration_list '}' {

            $$ = $4;
            tree_node_push_front( $$, $2 );
            tree_node_push_front( $$, $1 );
            tree_node_set_text_bounds( $$, NULL, $5 );
            $$->node_type = NODE_STRUCT_OR_UNION_SPECIFIER;
            $$->node_subtype = NODE_SU_DEFINITION;
        }
    | struct_or_union '{' struct_declaration_list '}' {

            $$ = $3;
            tree_node_push_front( $$, new_tree_node() );
            tree_node_push_front( $$, $1 );
            tree_node_set_text_bounds( $$, NULL, $4 );
            $$->node_type = NODE_STRUCT_OR_UNION_SPECIFIER;
            $$->node_subtype = NODE_SU_DEFINITION;
        }
    | struct_or_union IDENTIFIER {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            tree_node_set_child( $$, 1, $2 );
            $$->node_type = NODE_STRUCT_OR_UNION_SPECIFIER;
            $$->node_subtype = NODE_SU_DECLARATION;
        }
    ;

struct_or_union
    : STRUCT
    | UNION
    ;

struct_declaration_list
    : struct_declaration {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
        }
    | struct_declaration_list struct_declaration {

            tree_node_push_back( $$, $2 );
        }
    ;

struct_declaration
    : specifier_qualifier_list struct_declarator_list ';' {

            $$ = $2;
            tree_node_push_front( $$, $1 );
            tree_node_set_text_bounds( $$, NULL, $3 );
            $$->node_type = NODE_STRUCT_DECLARATION;
        }
    ;

specifier_qualifier_list
    : specifier_qualifier_list type_specifier {

            tree_node_push_back( $$, $2 );
        }
    | type_specifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER_LIST;
        }
    | specifier_qualifier_list type_qualifier {

            tree_node_push_back( $$, $2 );
        }
    | type_qualifier {

            $$ = new_tree_node();
            tree_node_set_child( $$, 0, $1 );
            $$->node_type = NODE_DECLARATION_SPECIFIER_LIST;
        }
    ;

struct_declarator_list
    : struct_declarator {
            /* TODO */
        }
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

