%{

#include <stdlib.h>
#include <stdio.h>
#include "tree_terminals.h"
#include "parser.tab.h"

int line = 1, column = 0;

static int proc_keyword ( int keyword );
static int proc_punctuator ( int punctuator );
static int proc_identifier ( void );
static int proc_constant ( int type, int modifiers , int suffix_len);
static int proc_string_literal ( int modifiers, int prefix_len );
static int proc_error ( void );

%}

nondigit              [_a-zA-Z]
digit                 [0-9]
nonzero_digit         [1-9]
oct_digit             [0-7]
hex_digit             [0-9a-fA-F]

hex_prefix            (0x|0X)
unsigned_suffix       (u|Ui)
long_suffix           (l|L)
long_long_suffix      (ll|LL)
float_suffix          (f|F)

sign                  (\-|\+)
digit_sequence        {digit}+
hex_digit_sequence    {hex_digit}+
c_char_sequence       ([^'\\\n]|\\[^\n])+
s_char_sequence       ([^"\\\n]|\\[^\n])*

hex_quad              {hex_digit}{4}
universal_char_name   (\\u{hex_quad}|\\U{hex_quad}{2})

identifier_nondigit   ({nondigit}|{universal_char_name})
identifier            {identifier_nondigit}({identifier_nondigit}|{digit})*

dec_constant          {nonzero_digit}{digit}*
oct_constant          0{oct_digit}*
hex_constant          {hex_prefix}{hex_digit}+
uint_constant         ({oct_constant}|{hex_constant})

frac_constant         ({digit_sequence}?\.{digit_sequence}|{digit_sequence}\.)
exponent_part         (e|E){sign}?{digit_sequence}
dec_floating_constant ({frac_constant}{exponent_part}?|{digit_sequence}{exponent_part})

hex_frac_constant     ({hex_digit_sequence}?\.{hex_digit_sequence}|{hex_digit_sequence}\.)
bin_exponent_part     (p|P){sign}?{digit_sequence}
hex_floating_constant {hex_prefix}({hex_frac_constant}|{hex_digit_sequence}){bin_exponent_part}

floating_constant     ({dec_floating_constant}|{hex_floating_constant})

%%

"auto"           { return proc_keyword( AUTO      ); }
"break"          { return proc_keyword( BREAK     ); }
"case"           { return proc_keyword( CASE      ); }
"char"           { return proc_keyword( CHAR      ); }
"const"          { return proc_keyword( CONST     ); }
"continue"       { return proc_keyword( CONTINUE  ); }
"default"        { return proc_keyword( DEFAULT   ); }
"do"             { return proc_keyword( DO        ); }
"double"         { return proc_keyword( DOUBLE    ); }
"else"           { return proc_keyword( ELSE      ); }
"enum"           { return proc_keyword( ENUM      ); }
"extern"         { return proc_keyword( EXTERN    ); }
"float"          { return proc_keyword( FLOAT     ); }
"for"            { return proc_keyword( FOR       ); }
"goto"           { return proc_keyword( GOTO      ); }
"if"             { return proc_keyword( IF        ); }
"inline"         { return proc_keyword( INLINE    ); }
"int"            { return proc_keyword( INT       ); }
"long"           { return proc_keyword( LONG      ); }
"register"       { return proc_keyword( REGISTER  ); }
"restrict"       { return proc_keyword( RESTRICT  ); }
"return"         { return proc_keyword( RETURN    ); }
"short"          { return proc_keyword( SHORT     ); }
"signed"         { return proc_keyword( SIGNED    ); }
"sizeof"         { return proc_keyword( SIZEOF    ); }
"static"         { return proc_keyword( STATIC    ); }
"struct"         { return proc_keyword( STRUCT    ); }
"switch"         { return proc_keyword( SWITCH    ); }
"typedef"        { return proc_keyword( TYPEDEF   ); }
"union"          { return proc_keyword( UNION     ); }
"unsigned"       { return proc_keyword( UNSIGNED  ); }
"void"           { return proc_keyword( VOID      ); }
"volatile"       { return proc_keyword( VOLATILE  ); }
"while"          { return proc_keyword( WHILE     ); }
"_Bool"          { return proc_keyword( _BOOL     ); }
"_Complex"       { return proc_keyword( _COMPLEX  ); }
"_Imaginary"     { return proc_keyword( _IMAGINARY ); }

"["              { return proc_punctuator( '['  ); }
"]"              { return proc_punctuator( ']'  ); }
"("              { return proc_punctuator( '('  ); }
")"              { return proc_punctuator( ')'  ); }
"{"              { return proc_punctuator( '{'  ); }
"}"              { return proc_punctuator( '}'  ); }
"."              { return proc_punctuator( '.'  ); }
"->"             { return proc_punctuator( POINTER ); }
"++"             { return proc_punctuator( INCREMENT ); }
"--"             { return proc_punctuator( DECREMENT ); }
"&"              { return proc_punctuator( '&'  ); }
"*"              { return proc_punctuator( '*'  ); }
"+"              { return proc_punctuator( '+'  ); }
"-"              { return proc_punctuator( '-'  ); }
"~"              { return proc_punctuator( '~'  ); }
"!"              { return proc_punctuator( '!'  ); }
"/"              { return proc_punctuator( '/'  ); }
"%"              { return proc_punctuator( '%'  ); }
"<<"             { return proc_punctuator( LSHIFT ); }
">>"             { return proc_punctuator( RSHIFT ); }
"<"              { return proc_punctuator( '<'  ); }
">"              { return proc_punctuator( '>'  ); }
"<="             { return proc_punctuator( LESS_EQUAL ); }
">="             { return proc_punctuator( MORE_EQUAL ); }
"=="             { return proc_punctuator( EQUAL ); }
"!="             { return proc_punctuator( NOT_EQUAL ); }
"^"              { return proc_punctuator( '^'  ); }
"|"              { return proc_punctuator( '|'  ); }
"&&"             { return proc_punctuator( AND ); }
"||"             { return proc_punctuator( OR ); }
"?"              { return proc_punctuator( '?'  ); }
":"              { return proc_punctuator( ':'  ); }
";"              { return proc_punctuator( ';'  ); }
"..."            { return proc_punctuator( ELLIPSIS ); }
"="              { return proc_punctuator( '='  ); }
"*="             { return proc_punctuator( MUL_ASSIGN ); }
"/="             { return proc_punctuator( DIV_ASSIGN ); }
"%="             { return proc_punctuator( MOD_ASSIGN ); }
"+="             { return proc_punctuator( ADD_ASSIGN ); }
"-="             { return proc_punctuator( SUB_ASSIGN ); }
"<<="            { return proc_punctuator( LSHIFT_ASSIGN ); }
">>="            { return proc_punctuator( RSHIFT_ASSIGN ); }
"&="             { return proc_punctuator( AND_ASSIGN ); }
"^="             { return proc_punctuator( XOR_ASSIGN ); }
"|="             { return proc_punctuator( OR_ASSIGN ); }
","              { return proc_punctuator( ','  ); }
"#"              { return proc_punctuator( '#'  ); }
"##"             { return proc_punctuator( PASTE ); }
"<:"             { return proc_punctuator( '['  ); }
":>"             { return proc_punctuator( ']'  ); }
"<%"             { return proc_punctuator( '{'  ); }
"%>"             { return proc_punctuator( '}'  ); }
"%:"             { return proc_punctuator( '#'  ); }
"%:%:"           { return proc_punctuator( PASTE ); }

{identifier}     { return proc_identifier(); }

{dec_constant} {

        return proc_constant( INT_CONSTANT, NO_MODIFIER, 0 );
    }

{dec_constant}{long_suffix} {

        return proc_constant( INT_CONSTANT, LONG_MODIFIER, 1 );
    }

{dec_constant}{long_long_suffix} {

        return proc_constant( INT_CONSTANT, LONG_LONG_MODIFIER, 1 );
    }

{dec_constant}{unsigned_suffix} {

        return proc_constant( INT_CONSTANT, UNSIGNED_MODIFIER, 1 );
    }

{dec_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        return proc_constant( INT_CONSTANT, UNSIGNED_MODIFIER | LONG_MODIFIER, 2 );
    }

{dec_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        return proc_constant( INT_CONSTANT, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER, 2 );
    }

{uint_constant} {

        return proc_constant( UINT_CONSTANT, NO_MODIFIER, 0 );
    }

{uint_constant}{long_suffix} {

        return proc_constant( UINT_CONSTANT, LONG_MODIFIER, 1 );
    }

{uint_constant}{long_long_suffix} {

        return proc_constant( UINT_CONSTANT, LONG_LONG_MODIFIER, 1 );
    }

{uint_constant}{unsigned_suffix} {

        return proc_constant( UINT_CONSTANT, UNSIGNED_MODIFIER, 1 );
    }

{uint_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        return proc_constant( UINT_CONSTANT, UNSIGNED_MODIFIER | LONG_MODIFIER, 2 );
    }

{uint_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        return proc_constant( UINT_CONSTANT, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER, 2 );
    }

{floating_constant} {

        return proc_constant( FLOAT_CONSTANT, NO_MODIFIER, 0 );
    }

{floating_constant}{float_suffix} {

        return proc_constant( FLOAT_CONSTANT, FLOAT_MODIFIER, 1 );
    }

{floating_constant}{long_suffix} {

        return proc_constant( FLOAT_CONSTANT, LONG_MODIFIER, 1 );
    }

'{c_char_sequence}' {

        return proc_constant( CHAR_CONSTANT, NO_MODIFIER, 0 );
    }

L'{c_char_sequence}' {

        return proc_constant( CHAR_CONSTANT, WIDE_CHAR_MODIFIER, 1 );
    }

\"{s_char_sequence}\" {

        return proc_string_literal( NO_MODIFIER, 0 );
    }

L\"{s_char_sequence}\" {

        return proc_string_literal( WIDE_CHAR_MODIFIER, 1 );
    }

[ \t\v\r\f]      { column++; }

\n               { column = 0; line++; }

.                { return proc_error(); }

%%

static inline void move ( void ) {

    column += yyleng;
}

static void save ( struct token *token ) {

    token->line = line;
    token->column = column;
    token->textlen = yyleng;
    token->text = malloc( yyleng + 1 );

    if ( token->text ) {
        memcpy( token->text, yytext, yyleng + 1 );
    } else {
        yyerror( "Out of memory error." );
    }
}

static int proc_keyword ( int keyword ) {

    save( &(yylval.keyword.token) );

    yylval.keyword.keyword = keyword;

    move();

    return keyword;
}

static int proc_punctuator ( int punctuator ) {

    save( &(yylval.punctuator.token) );

    yylval.punctuator.punctuator = punctuator;

    move();

    return punctuator;
}

static int proc_identifier ( void ) {

    save( &(yylval.identifier.token) );

    move();

    return IDENTIFIER;
}

static int proc_constant ( int type, int modifiers, int suffix_len ) {

    save( &(yylval.constant.token) );

    yylval.constant.type = type;
    yylval.constant.modifiers = modifiers;

    move();

    return CONSTANT;
}

static int proc_string_literal ( int modifiers, int prefix_len ) {

    save( &(yylval.string_literal.token) );

    yylval.string_literal.modifiers = modifiers;

    move();

    return STRING_LITERAL;
}

static int proc_error ( void ) {

    // TODO: consume until a space is reached

    yyerror( "Parse error at line %d, column %d." );

    return PARSE_ERROR;
}

int yywrap ( void ) {

    return 0;
}

void yyerror ( char * const str ) {

    fflush( stdout );
    printf( str, line, column );
    printf( "\n" );
    exit( 1 );
}

