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

%token <identifier> IDENTIFIER
%token <string_literal> STRING_LITERAL
%token <constant> CONSTANT
%token <keyword> BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM
%token <keyword> EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT
%token <keyword> RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION
%token <keyword> UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY

%start start

%%

start: IDENTIFIER | STRING_LITERAL | CONSTANT;

%%

// TODO

