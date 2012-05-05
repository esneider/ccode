%{

#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"

int line = 1, column = 0;

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

"break"          { return proc_keyword('brea'); }
"case"           { return proc_keyword('case'); }
"char"           { return proc_keyword('char'); }
"const"          { return proc_keyword('cons'); }
"continue"       { return proc_keyword('cont'); }
"default"        { return proc_keyword('defa'); }
"do"             { return proc_keyword('do'); }
"double"         { return proc_keyword('doub'); }
"else"           { return proc_keyword('else'); }
"enum"           { return proc_keyword('enum'); }
"extern"         { return proc_keyword('exte'); }
"float"          { return proc_keyword('floa'); }
"for"            { return proc_keyword('for'); }
"goto"           { return proc_keyword('goto'); }
"if"             { return proc_keyword('if'); }
"inline"         { return proc_keyword('inli'); }
"int"            { return proc_keyword('int'); }
"long"           { return proc_keyword('long'); }
"register"       { return proc_keyword('regi'); }
"restrict"       { return proc_keyword('rest'); }
"return"         { return proc_keyword('retu'); }
"short"          { return proc_keyword('shor'); }
"signed"         { return proc_keyword('sign'); }
"sizeof"         { return proc_keyword('size'); }
"static"         { return proc_keyword('stat'); }
"struct"         { return proc_keyword('stru'); }
"switch"         { return proc_keyword('swit'); }
"typedef"        { return proc_keyword('type'); }
"union"          { return proc_keyword('unio'); }
"unsigned"       { return proc_keyword('unsi'); }
"void"           { return proc_keyword('void'); }
"volatile"       { return proc_keyword('vola'); }
"while"          { return proc_keyword('whil'); }
"_Bool"          { return proc_keyword('_Boo'); }
"_Complex"       { return proc_keyword('_Com'); }
"_Imaginary"     { return proc_keyword('_Ima'); }

"["              { return proc_punctuator('['); }
"]"              { return proc_punctuator(']'); }
"("              { return proc_punctuator('('); }
")"              { return proc_punctuator(')'); }
"{"              { return proc_punctuator('{'); }
"}"              { return proc_punctuator('}'); }
"."              { return proc_punctuator('.'); }
"->"             { return proc_punctuator('->'); }
"++"             { return proc_punctuator('++'); }
"--"             { return proc_punctuator('--'); }
"&"              { return proc_punctuator('&'); }
"*"              { return proc_punctuator('*'); }
"+"              { return proc_punctuator('+'); }
"-"              { return proc_punctuator('-'); }
"~"              { return proc_punctuator('~'); }
"!"              { return proc_punctuator('!'); }
"/"              { return proc_punctuator('/'); }
"%"              { return proc_punctuator('%'); }
"<<"             { return proc_punctuator('<<'); }
">>"             { return proc_punctuator('>>'); }
"<"              { return proc_punctuator('<'); }
">"              { return proc_punctuator('>'); }
"<="             { return proc_punctuator('<='); }
">="             { return proc_punctuator('>='); }
"=="             { return proc_punctuator('=='); }
"!="             { return proc_punctuator('!='); }
"^"              { return proc_punctuator('^'); }
"|"              { return proc_punctuator('|'); }
"&&"             { return proc_punctuator('&&'); }
"||"             { return proc_punctuator('||'); }
"?"              { return proc_punctuator('?'); }
":"              { return proc_punctuator(':'); }
";"              { return proc_punctuator(';'); }
"..."            { return proc_punctuator('...'); }
"="              { return proc_punctuator('='); }
"*="             { return proc_punctuator('*='); }
"/="             { return proc_punctuator('/='); }
"%="             { return proc_punctuator('%='); }
"+="             { return proc_punctuator('+='); }
"-="             { return proc_punctuator('-='); }
"<<="            { return proc_punctuator('<<='); }
">>="            { return proc_punctuator('>>='); }
"&="             { return proc_punctuator('&='); }
"^="             { return proc_punctuator('^='); }
"|="             { return proc_punctuator('|='); }
","              { return proc_punctuator(','); }
"#"              { return proc_punctuator('#'); }
"##"             { return proc_punctuator('##'); }
"<:"             { return proc_punctuator('['); }
":>"             { return proc_punctuator(']'); }
"<%"             { return proc_punctuator('{'); }
"%>"             { return proc_punctuator('}'); }
"%:"             { return proc_punctuator('#'); }
"%:%:"           { return proc_punctuator('##'); }

{identifier}     { return proc_identifier(); }

[ \t\v\r\f]      { column++; }

\n               { column = 0; line++; }

.                { yyerror( "Parse error at line %d, column %d." ); }

{dec_constant} {

        return proc_constant( INT_CONSTANT, 0, NO_MODIFIER );
    }

{dec_constant}{long_suffix} {

        return proc_constant( INT_CONSTANT, 1, LONG_MODIFIER );
    }

{dec_constant}{long_long_suffix} {

        return proc_constant( INT_CONSTANT, 1, LONG_LONG_MODIFIER );
    }

{dec_constant}{unsigned_suffix} {

        return proc_constant( INT_CONSTANT, 1, UNSIGNED_MODIFIER);
    }

{dec_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        return proc_constant( INT_CONSTANT, 2, UNSIGNED_MODIFIER | LONG_MODIFIER);
    }

{dec_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        return proc_constant( INT_CONSTANT, 2, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER );
    }

{uint_constant} {

        return proc_constant( UINT_CONSTANT, 0, NO_MODIFIER );
    }

{uint_constant}{long_suffix} {

        return proc_constant( UINT_CONSTANT, 1, LONG_MODIFIER );
    }

{uint_constant}{long_long_suffix} {

        return proc_constant( UINT_CONSTANT, 1, LONG_LONG_MODIFIER );
    }

{uint_constant}{unsigned_suffix} {

        return proc_constant( UINT_CONSTANT, 1, UNSIGNED_MODIFIER );
    }

{uint_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        return proc_constant( UINT_CONSTANT, 2, UNSIGNED_MODIFIER | LONG_MODIFIER );
    }

{uint_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        return proc_constant( UINT_CONSTANT, 2, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER );
    }

{floating_constant} {

        return proc_constant( FLOAT_CONSTANT, 0, NO_MODIFIER );
    }

{floating_constant}{float_suffix} {

        return proc_constant( FLOAT_CONSTANT, 1, FLOAT_MODIFIER );
    }

{floating_constant}{long_suffix} {

        return proc_constant( FLOAT_CONSTANT, 1, LONG_MODIFIER );
    }

'{c_char_sequence}' {

        return proc_constant( CHAR_CONSTANT, 0, NO_MODIFIER );
    }

L'{c_char_sequence}' {

        return proc_constant( CHAR_CONSTANT, 1, WIDE_CHAR_MODIFIER );
    }

"{s_char_sequence}" {

        return proc_string_literal( 0, NO_MODIFIER );
    }

L"{s_char_sequence}" {

        return proc_string_literal( 1, WIDE_CHAR_MODIFIER );
    }

%%

static inline void move ( void ) {

    column += yyleng;
}

static inline void save ( struct token *token ) {

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

static int proc_integer_constant ( int type, int suffix_len, int modifiers ) {

    save( &(yylval.constant.token) );

    yylval.constant.type = type;
    yylval.constant.modifiers = modifiers;
    yylval.constant.token.textlen -= suffix_len;

    move();
    return CONSTANT;
}

static int proc_string_literal ( int prefix_len, int modifiers ) {

    save( &(yylval.string_literal.token) );

    yylval.string_literal.modifiers = modifiers;
    yylval.string_literal.token.textlen -= prefix_len;

    move();
    return STRING_LITERAL;
}

int yywrap ( void ) {

    return 0;
}

void yyerror ( const char *str ) {

    fflush( stdout );
    printf( str, line, column );
    printf( "\n" );
    yyterminate();
}

