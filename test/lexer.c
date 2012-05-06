#include <stdio.h>
#include <stdlib.h>
#include "tree_terminals.h"
#include "parser.tab.h"

YYSTYPE yylval;

int yylex( void );

int main ( void ) {

    int ret;

    while ( ret = yylex() ) {

        printf( "%d %.4s (%s)\n", ret, (char*)&ret, yylval.constant.token.text );
    }

    return 0;
}
