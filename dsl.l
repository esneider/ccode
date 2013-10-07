/**
 * These go before the parser token:
 *
 * [number] - Insert child in position 'number'.
 * [<] - Push child front.
 * [>] - Push child back.
 * [=] - Use this node instead of creating a new one.
 *
 * These go anywhere in the parser expression:
 *
 * [+] - Create a new node with the contents until the next [-].
 * [-] - End new node context.
 *
 * These go at the end of a parser expression:
 *
 * [identifier] - Set node type to 'identifier'.
 * [:identifier] - Set node subtype to 'identifier'.
 * [ident1:ident2] - Set node type and subtype.
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


static int line = 1, column = 0, buffer_pos = 0;


#define STR_MAX 100


static struct type {

    char type   [ STR_MAX + 1 ];
    char subtype[ STR_MAX + 1 ];
};


static struct rule {

    struct type type;

    static struct node {

        struct type type;

        int limits[2];

        struct node *parent;

        static struct component {

            int pos, number;

            enum { IGNORE, ABSOLUTE, PUSH_FRONT, PUSH_BACK, COPY } type;

            struct node *child;

            struct component *next;

        } component;

    } node;
};


static struct current {

    struct rule rule;

    struct node* node;

    struct component *component;

    struct type *type;

} current;


%}


nondigit            [_a-zA-Z]
digit               [0-9]
hex_digit           [0-9a-fA-F]
whitespace          [ \t\v\r\f]

char_sequence       ([^'\\\n]|\\[^\n])+

hex_quad            {hex_digit}{4}
universal_char_name (\\u{hex_quad}|\\U{hex_quad}{2})

identifier_nondigit ({nondigit}|{universal_char_name})
identifier          {identifier_nondigit}({identifier_nondigit}|{digit})*


%x HEADER HEADER_CODE BODY TAIL LINE_COMMENT COMMENT RULE TYPE MID_TYPE SUBTYPE COMPONENTS MODIFIERS CLOSE_MOD
%start HEADER


%option stack


%%


<HEADER> {
    [^%\n]+           { move( true ); }
    "%%"              { move( true ); BEGIN( BODY ); }
    "%{"              { move( true ); BEGIN( HEADER_CODE ); }
    .                 { move( true ); }
}

<HEADER_CODE> {
    [^%/\n]+          { move( true ); }
    "%}"              { move( true ); BEGIN( HEADER ); }
    "//"              { move( true ); yy_push_state( LINE_COMMENT ); }
    "/*"              { move( true ); yy_push_state( COMMENT ); }
    .                 { move( true ); }
}

<LINE_COMMENT> {
    [^\n]+            { move( true ); }
    "\n"              { move( true ); yy_pop_state(); }
}

<COMMENT> {
    [^*\n]+           { move( true ); }
    "*/"              { move( true ); yy_pop_state(); }
    .                 { move( true ); }
}

<BODY> {
    "%%"              { move( true ); BEGIN( TAIL ); }
    {identifier}      { move( true ); init_rule(); BEGIN( RULE ); }
    {whitespace}+     { move( true ); }
    "\n"              { move( true ); }
    .                 { move( true ); }
}

<TAIL> {
    <<EOF>>           { return 0; }
    .+                { move( true ); }
}

<RULE> {
    {whitespace}+     { move( true ); }
    "\n"              { move( true ); }
    "["               { printf( "/*" ); move( true ); yy_push_state( TYPE ); }
    ":"               { move( true ); current.type = &current.node->type; BEGIN( COMPONENTS ); }
    .                 { /* error */ }
}

<TYPE> {
    {whitespace}+     { move( true ); }
    {identifier}      { move( true ); strncpy( current.type->type, yytext, STR_MAX); BEGIN( MID_TYPE ); }
    ":"               { move( true ); BEGIN( SUBTYPE ); }
    "\n"              { move( true ); }
    .                 { /* error */ }
}

<MID_TYPE> {
    {whitespace}+     { move( true ); }
    ":"               { move( true ); BEGIN( SUBTYPE ); }
    "]"               { move( true ); printf( "*/" ); yy_pop_state(); }
    "\n"              { move( true ); }
    .                 { /* error */ }
}

<SUBTYPE> {
    {whitespace}+     { move( true ); }
    {identifier}      { move( true ); strncpy( current.type->subtype, yytext, STR_MAX); BEGIN( CLOSE_MOD ); }
    "\n"              { move( true ); }
    .                 { /* error */ }
}

<COMPONENTS> {
    {whitespace}+     { move( true ); }
    {identifier}      { printf( " " ); move( true ); add_component(); }
    '{char_sequence}' { printf( " " ); move( true ); add_component(); }
    "["               { printf( "/*" ); move( true ); yy_push_state( MODIFIERS ); }
    "|"               { move( true ); /* TODO */ }
    ";"               { move( true ); /* TODO */ BEGIN( BODY ); }
    "{"               { move( false ); /* TODO */ }
    "/*"              { move( true ); yy_push_state( LINE_COMMENT ); }
    "//"              { move( true ); yy_push_state( COMMENT ); }
    "\n"              { move( true ); }
    .                 { /* error */ }
}

<MODIFIERS> {
    {whitespace}+     { move( true ); }
    {identifier}      { move( true ); strncpy( current.type->type, yytext, STR_MAX); BEGIN( MID_TYPE ); }
    ":"               { move( true ); BEGIN( SUBTYPE ); }
    "+"               { move( true ); add_child(); BEGIN( CLOSE_MOD ); }
    "-"               { move( true ); /* TODO (remember to maintain current.type) */ BEGIN( CLOSE_MOD ); }
    "<"{digit}*       { move( true ); add_option( PUSH_FRONT, yytext + 1 ); BEGIN( CLOSE_MOD ); }
    ">"{digit}*       { move( true ); add_option( PUSH_BACK, yytext + 1 ); BEGIN( CLOSE_MOD ); }
    "="               { move( true ); add_option( COPY, yytext + 1 ); BEGIN( CLOSE_MOD ); }
    {digit}+          { move( true ); add_option( ABSOLUTE, yytext ); BEGIN( CLOSE_MOD ); }
    "\n"              { move( true ); }
    .                 { /* error */ }
}

<CLOSE_MOD> {
    {whitespace}+     { move( true ); }
    "\n"              { move( true ); }
    "]"               { move( true ); printf( "*/" ); yy_pop_state(); }
    .                 { /* error */ }
}


%%


static inline void move ( bool print ) {

    if ( print ) printf( yytext );

    if ( yyleng != 1 || yytext[0] != '\n' ) {

        column += yyleng;

    } else {

        column = 0;
        line++;
    }

    buffer_pos += yyleng;
}


static void clear_node ( struct node *node ) {

    if ( !node ) return;

    memset( node, '\0', offsetof( struct node, parent ) );

    for ( struct component *c = &node->component; !c || c->type != IGNORE; c = c->next ) {

        clear_node( c->child );

        memset( c, '\0', offsetof( struct component, child ) );
    }
}


static void init_node ( void ) {

    current.node      = &current.rule.node;
    current.component = &current.rule.node.component;

    clear_node( current.node );
}


static void init_rule ( void ) {

    current.type = &current.rule.type;

    memset( current.type, '\0', sizeof( struct type ) );

    init_node();
}


static void add_component ( void ) {

    current.component->pos++;

    if ( current.component->type == IGNORE ) return;

    if ( current.component->next == NULL ) {

        current.component->next = calloc( sizeof( struct component ) );

        if ( !current.component->next ) {
            /* memory error */
        }
    }

    current.component->next->pos = current.component->pos;
    current.component = current.component->next;

    current.pos++;
}


static void add_child ( void ) {

    if ( current.component->child == NULL ) {

        current.component->child = calloc( sizeof( struct node ) );

        if ( !current.component->child ) {
            /* memory error */
        }

        current.component->child->father = current.component;
    }

    current.node = current.component->child;
    current.type = &current.node->type;
    current.node->component.pos = current.component->pos;
    current.component = &current.node->component;
}


static void add_option ( int type, const char *num ) {

    if ( current.component->type != IGNORE ) {
        /* error */
    }

    current.component->type = type;
    current.component->number = atoi( num );
}


int yywrap ( void ) {

    return 0;
}

