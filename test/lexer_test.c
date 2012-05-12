#include <stdio.h>
#include <stdlib.h>

#define YYSTYPE struct tree_node*

#include "tree_node.h"

YYSTYPE yylval;

int yylex( void );

char *buffer;


int main ( void ) {

    int ret, file_size;

    int buffer_state;

    FILE *file = fopen( "sample.c", "rb" );

    if ( !file ) {
        printf( "file error\n" );
        return 1;
    }

    fseek( file, 0, SEEK_END );
    file_size = ftell( file );
    fseek( file, 0, SEEK_SET );


    buffer = calloc( file_size + 2, 1 );

    if ( !buffer ) {
        printf( "memory error\n" );
        return 1;
    }

    fread( buffer, 1, file_size, file );

    buffer_state = yy_scan_buffer( buffer, file_size + 2 );

    if ( !buffer_state ) {
        printf( "buffer state error\n" );
        return 1;
    }

    while ( ret = yylex() ) {

        printf( "%d (%.*s)\n", ret, yylval->text_length, yylval->text );
    }

    free( buffer );

    return 0;
}
