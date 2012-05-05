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

%%

%%

// TODO
