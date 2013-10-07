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

primary_expression [EXPRESSION]
    : [1]IDENTIFIER         [:IDENTIFIER]
    | [1]CONSTANT           [:CONSTANT]
    | [1]STRING_LITERAL     [:STRING_LITERAL]
    | '(' [1]expression ')' [:EXPRESSION]
    ;

postfix_expression [EXPRESSION]
    : [=]primary_expression
    | [1]postfix_expression '[' [2]expression ']'               [:ARRAY_SUBSCRIPTING]
    | [<]postfix_expression '(' [=]argument_expression_list ')' [:FUNCTION_CALL]
    | [1]postfix_expression '(' ')'                             [:FUNCTION_CALL]
    | [1]postfix_expression '.' [2]IDENTIFIER                   [:MEMBER]
    | [1]postfix_expression POINTER [2]IDENTIFIER               [:POINTER_MEMBER]
    | [1]postfix_expression [2]INCREMENT                        [:UNARY_POSTFIX]
    | [1]postfix_expression [2]DECREMENT                        [:UNARY_POSTFIX]
    | '(' [<]type_name ')' '{' [=]initializer_list '}'          [:COMPOUND_LITERAL]
    | '(' [<]type_name ')' '{' [=]initializer_list ',' '}'      [:COMPOUND_LITERAL]
    ;

argument_expression_list
    : [1]assignment_expression
    | [=]argument_expression_list ',' [>]assignment_expression
    ;

unary_expression [EXPRESSION]
    : [=]postfix_expression
    | [1]INCREMENT [2]unary_expression     [:UNARY_PREFIX]
    | [1]DECREMENT [2]unary_expression     [:UNARY_PREFIX]
    | [1]unary_operator [2]cast_expression [:UNARY_PREFIX]
    | SIZEOF [1]unary_expression           [:SIZEOF_EXPRESSION]
    | SIZEOF '(' [1]type_name ')'          [:SIZEOF_TYPE_NAME]
    ;

unary_operator
    : [=]'&'
    | [=]'*'
    | [=]'+'
    | [=]'-'
    | [=]'~'
    | [=]'!'
    ;

cast_expression [EXPRESSION]
    : [=]unary_expression
    | '(' [1]type_name ')' [2]cast_expression [:CAST]
    ;

multiplicative_expression [EXPRESSION]
    : [=]cast_expression
    | [1]multiplicative_expression [2]'*' [3]cast_expression [:BINARY]
    | [1]multiplicative_expression [2]'/' [3]cast_expression [:BINARY]
    | [1]multiplicative_expression [2]'%' [3]cast_expression [:BINARY]
    ;

additive_expression [EXPRESSION]
    : [=]multiplicative_expression
    | [1]additive_expression [2]'+' [3]multiplicative_expression [:BINARY]
    | [1]additive_expression [2]'-' [3]multiplicative_expression [:BINARY]
    ;

shift_expression [EXPRESSION]
    : [=]additive_expression
    | [1]shift_expression [2]LSHIFT [3]additive_expression [:BINARY]
    | [1]shift_expression [2]RSHIFT [3]additive_expression [:BINARY]
    ;

relational_expression [EXPRESSION]
    : [=]shift_expression
    | [1]relational_expression [2]'<' [3]shift_expression        [:BINARY]
    | [1]relational_expression [2]'>' [3]shift_expression        [:BINARY]
    | [1]relational_expression [2]LESS_EQUAL [3]shift_expression [:BINARY]
    | [1]relational_expression [2]MORE_EQUAL [3]shift_expression [:BINARY]
    ;

equality_expression [EXPRESSION]
    : [=]relational_expression
    | [1]equality_expression [2]EQUAL [3]relational_expression     [:BINARY]
    | [1]equality_expression [2]NOT_EQUAL [3]relational_expression [:BINARY]
    ;

AND_expression [EXPRESSION]
    : [=]equality_expression
    | [1]AND_expression [2]'&' [3]equality_expression [:BINARY]
    ;

exclusive_OR_expression [EXPRESSION]
    : [=]AND_expression
    | [1]exclusive_OR_expression [2]'^' [3]AND_expression [:BINARY]
    ;

inclusive_OR_expression [EXPRESSION]
    : [=]exclusive_OR_expression
    | [1]inclusive_OR_expression [2]'|' [3]exclusive_OR_expression [:BINARY]
    ;

logical_AND_expression [EXPRESSION]
    : [=]inclusive_OR_expression
    | [1]logical_AND_expression [2]LOGICAL_AND [3]inclusive_OR_expression [:BINARY]
    ;

logical_OR_expression [EXPRESSION]
    : [=]logical_AND_expression
    | [1]logical_OR_expression [2]LOGICAL_OR [3]logical_AND_expression [:BINARY]
    ;

conditional_expression [EXPRESSION]
    : [=]logical_OR_expression
    | [1]logical_OR_expression '?' [2]expression ':' [3]conditional_expression [:CONDITIONAL]
    ;

assignment_expression [EXPRESSION]
    : [=]conditional_expression
    | [1]unary_expression [2]assignment_operator [3]assignment_expression [:ASSIGNMENT]
    ;

assignment_operator
    : [=]'='
    | [=]MUL_ASSIGN
    | [=]DIV_ASSIGN
    | [=]MOD_ASSIGN
    | [=]ADD_ASSIGN
    | [=]SUB_ASSIGN
    | [=]LSHIFT_ASSIGN
    | [=]RSHIFT_ASSIGN
    | [=]AND_ASSIGN
    | [=]XOR_ASSIGN
    | [=]OR_ASSIGN
    ;

expression [EXPRESSION]
    : [=]assignment_expression
    | [1]expression ',' [2]assignment_expression [:COMMA]
    ;

constant_expression
    : [=]conditional_expression
    ;

declaration [DECLARATION]
    : [<]declaration_specifiers [=]init_declarator_list ';'
    | [1]declaration_specifiers ';'
    ;

declaration_specifiers [DECLARATION_SPECIFIER_LIST]
    : [=]declaration_specifiers [>]storage_class_specifier
    | [1]storage_class_specifier
    | [=]declaration_specifiers [>]type_specifier
    | [1]type_specifier
    | [=]declaration_specifiers [>]type_qualifier
    | [1]type_qualifier
    | [=]declaration_specifiers [>]function_specifier
    | [1]function_specifier
    ;

init_declarator_list
    : [1]init_declarator
    | [=]init_declarator_list ',' [>]init_declarator
    ;

init_declarator [INIT_DECLARATOR]
    : [1]declarator                    [:UNINITIALIZED]
    | [1]declarator '=' [2]initializer [:INITIALIZED]
    ;

storage_class_specifier [DECLARATION_SPECIFIER:STORAGE_CLASS]
    : [1]TYPEDEF
    | [1]EXTERN
    | [1]STATIC
    | [1]AUTO
    | [1]REGISTER
    ;

type_specifier [DECLARATION_SPECIFIER:SP_TYPE]
    : [1]VOID
    | [1]CHAR
    | [1]SHORT
    | [1]INT
    | [1]LONG
    | [1]FLOAT
    | [1]DOUBLE
    | [1]SIGNED
    | [1]UNSIGNED
    | [1]_BOOL
    | [1]_COMPLEX
    | [1]struct_or_union_specifier
    | [1]enum_specifier
    | [1]typedef_name
    ;

struct_or_union_specifier [STRUCT_OR_UNION_SPECIFIER]
    : [<2]struct_or_union [<1]IDENTIFIER '{' [=]struct_declaration_list '}' [:DEFINITION]
    | [<2]struct_or_union [<1][+][-] '{' [=]struct_declaration_list '}'     [:DEFINITION]
    | [1]struct_or_union [2]IDENTIFIER                                      [:DECLARATION]
    ;

struct_or_union
    : [=]STRUCT
    | [=]UNION
    ;

struct_declaration_list
    : [1]struct_declaration
    | [=]struct_declaration_list [>]struct_declaration
    ;

struct_declaration [STRUCT_DECLARATION]
    : [<]specifier_qualifier_list [=]struct_declarator_list ';'
    ;

specifier_qualifier_list [DECLARATION_SPECIFIER_LIST]
    : [=]specifier_qualifier_list [>]type_specifier
    | [1]type_specifier
    | [=]specifier_qualifier_list [>]type_qualifier
    | [1]type_qualifier
    ;

struct_declarator_list
    : [1]struct_declarator
    | [=]struct_declarator_list ',' [>]struct_declarator
    ;

struct_declarator [STRUCT_DECLARATOR]
    : [1]declarator
    | [1]declarator ':' [2]constant_expression
    | ':' [2]constant_expression
    ;

enum_specifier [ENUM_SPECIFIER]
    : ENUM [<]IDENTIFIER '{' [=]enumerator_list '}'     [:DEFINITION]
    | ENUM '{' [=]enumerator_list '}' [<][+][-]         [:DEFINITION]
    | ENUM [<]IDENTIFIER '{' [=]enumerator_list ',' '}' [:DEFINITION]
    | ENUM '{' [=]enumerator_list ',' '}' [<][+][-]     [:DEFINITION]
    | ENUM [1]IDENTIFIER                                [:DECLARATION]
    ;

enumerator_list
    : [1]enumerator
    | [=]enumerator_list ',' [>]enumerator
    ;

enumerator [ENUMERATOR]
    : [1]IDENTIFIER
    | [1]IDENTIFIER '=' [2]constant_expression
    ;

type_qualifier [DECLARATION_SPECIFIER:QU_TYPE]
    : [1]CONST
    | [1]RESTRICT
    | [1]VOLATILE
    ;

function_specifier [DECLARATION_SPECIFIER:SP_FUNCTION]
    : [1]INLINE
    ;

declarator [DECLARATOR]
    : [<]pointer [=]direct_declarator
    | [=]direct_declarator
    ;

direct_declarator
    : [1][DIRECT_DECLARATOR:IDENTIFIER]IDENTIFIER
    | [1][+] '(' [1][DIRECT_DECLARATOR:DECLARATOR]declarator ')' [-]
    | [=]direct_declarator [>][+] '[' [=]type_qualifier_list [<]assignment_expression ']' [DIRECT_DECLARATOR:ARRAY][-]
    | [=]direct_declarator [>][+] '[' [=]type_qualifier_list [<][+][-] ']' [DIRECT_DECLARATOR:ARRAY][-]
    | [=]direct_declarator [>][+] '[' [=]assignment_expression ']' [DIRECT_DECLARATOR:ARRAY][-]
    | [=]direct_declarator [>][+] '[' ']' [DIRECT_DECLARATOR:ARRAY][-]
    | [=]direct_declarator [>][+] '[' STATIC [=]type_qualifier_list [<]assignment_expression ']' [DIRECT_DECLARATOR:STATIC_ARRAY][-]
    | [=]direct_declarator [>][+] '[' STATIC [=]assignment_expression ']' [DIRECT_DECLARATOR:STATIC_ARRAY][-]
    | [=]direct_declarator [>][+] '[' [=]type_qualifier_list STATIC [<]assignment_expression ']' [DIRECT_DECLARATOR:STATIC_ARRAY][-]
    | [=]direct_declarator [>][+] '[' [=]type_qualifier_list '*' ']' [DIRECT_DECLARATOR:STAR_ARRAY][-]
    | [=]direct_declarator [>][+] '[' '*' ']' [DIRECT_DECLARATOR:STAR_ARRAY][-]
    | [=]direct_declarator [>][+] '(' [=]parameter_type_list ')' [DIRECT_DECLARATOR:FUNCTION][-]
    | [=]direct_declarator [>][+] '(' [=]identifier_list ')' [DIRECT_DECLARATOR:OLD_FUNCTION][-]
    | [=]direct_declarator [>][+] '(' ')' [DIRECT_DECLARATOR:OLD_FUNCTION][-]
    ;

pointer [POINTER]
    : '*' [1]type_qualifier_list
    | '*' [1][+][-]
    | [=]pointer '*' [>]type_qualifier_list
    | [=]pointer [>][+] '*' [-]
    ;

type_qualifier_list [QUALIFIER_LIST]
    : [1]type_qualifier
    | [=]type_qualifier_list [>]type_qualifier
    ;

parameter_type_list
    : parameter_list {
            /* TODO */
        }
    | parameter_list ',' ELLIPSIS {
            /* TODO */
        }
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

