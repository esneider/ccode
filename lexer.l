%{

#define YYSTYPE struct tree_node*

#include "tree_node.h"


struct tree_node *last_token = NULL;

int line = 1, column = 0, buffer_pos = 0;


static int proc_keyword ( int keyword );
static int proc_punctuator ( int punctuator );
static int proc_identifier ( void );
static int proc_constant ( int type, int modifiers, int suffix_len );
static int proc_string_literal ( int modifiers, int prefix_len );
static void proc_whitespace ( void );
static void proc_directive ( void );


extern char *buffer;

%}

nondigit              [_a-zA-Z]
digit                 [0-9]
nonzero_digit         [1-9]
oct_digit             [0-7]
hex_digit             [0-9a-fA-F]
whitespace            [ \t\v\r\f]

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

directive             ^{whitespace}*#[^\n]*

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

"["              { return proc_punctuator( '[' ); }
"]"              { return proc_punctuator( ']' ); }
"("              { return proc_punctuator( '(' ); }
")"              { return proc_punctuator( ')' ); }
"{"              { return proc_punctuator( '{' ); }
"}"              { return proc_punctuator( '}' ); }
"."              { return proc_punctuator( '.' ); }
"->"             { return proc_punctuator( POINTER ); }
"++"             { return proc_punctuator( INCREMENT ); }
"--"             { return proc_punctuator( DECREMENT ); }
"&"              { return proc_punctuator( '&' ); }
"*"              { return proc_punctuator( '*' ); }
"+"              { return proc_punctuator( '+' ); }
"-"              { return proc_punctuator( '-' ); }
"~"              { return proc_punctuator( '~' ); }
"!"              { return proc_punctuator( '!' ); }
"/"              { return proc_punctuator( '/' ); }
"%"              { return proc_punctuator( '%' ); }
"<<"             { return proc_punctuator( LSHIFT ); }
">>"             { return proc_punctuator( RSHIFT ); }
"<"              { return proc_punctuator( '<' ); }
">"              { return proc_punctuator( '>' ); }
"<="             { return proc_punctuator( LESS_EQUAL ); }
">="             { return proc_punctuator( MORE_EQUAL ); }
"=="             { return proc_punctuator( EQUAL ); }
"!="             { return proc_punctuator( NOT_EQUAL ); }
"^"              { return proc_punctuator( '^' ); }
"|"              { return proc_punctuator( '|' ); }
"&&"             { return proc_punctuator( LOGICAL_AND ); }
"||"             { return proc_punctuator( LOGICAL_OR ); }
"?"              { return proc_punctuator( '?' ); }
":"              { return proc_punctuator( ':' ); }
";"              { return proc_punctuator( ';' ); }
"..."            { return proc_punctuator( ELLIPSIS ); }
"="              { return proc_punctuator( '=' ); }
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
","              { return proc_punctuator( ',' ); }
"#"              { return proc_punctuator( '#' ); }
"##"             { return proc_punctuator( PASTE ); }
"<:"             { return proc_punctuator( '[' ); }
":>"             { return proc_punctuator( ']' ); }
"<%"             { return proc_punctuator( '{' ); }
"%>"             { return proc_punctuator( '}' ); }
"%:"             { return proc_punctuator( '#' ); }
"%:%:"           { return proc_punctuator( PASTE ); }

{identifier}     { return proc_identifier(); }

{directive}      { proc_directive(); }

{dec_constant} {

        return proc_constant( NODE_CN_INTEGER, NO_MODIFIER, 0 );
    }

{dec_constant}{long_suffix} {

        return proc_constant( NODE_CN_INTEGER, LONG_MODIFIER, 1 );
    }

{dec_constant}{long_long_suffix} {

        return proc_constant( NODE_CN_INTEGER, LONG_LONG_MODIFIER, 1 );
    }

{dec_constant}{unsigned_suffix} {

        return proc_constant( NODE_CN_INTEGER, UNSIGNED_MODIFIER, 1 );
    }

{dec_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        return proc_constant( NODE_CN_INTEGER, UNSIGNED_MODIFIER | LONG_MODIFIER, 2 );
    }

{dec_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        return proc_constant( NODE_CN_INTEGER, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER, 2 );
    }

{uint_constant} {

        return proc_constant( NODE_CN_UNSIGNED, NO_MODIFIER, 0 );
    }

{uint_constant}{long_suffix} {

        return proc_constant( NODE_CN_UNSIGNED, LONG_MODIFIER, 1 );
    }

{uint_constant}{long_long_suffix} {

        return proc_constant( NODE_CN_UNSIGNED, LONG_LONG_MODIFIER, 1 );
    }

{uint_constant}{unsigned_suffix} {

        return proc_constant( NODE_CN_UNSIGNED, UNSIGNED_MODIFIER, 1 );
    }

{uint_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        return proc_constant( NODE_CN_UNSIGNED, UNSIGNED_MODIFIER | LONG_MODIFIER, 2 );
    }

{uint_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        return proc_constant( NODE_CN_UNSIGNED, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER, 2 );
    }

{floating_constant} {

        return proc_constant( NODE_CN_FLOATING, NO_MODIFIER, 0 );
    }

{floating_constant}{float_suffix} {

        return proc_constant( NODE_CN_FLOATING, FLOAT_MODIFIER, 1 );
    }

{floating_constant}{long_suffix} {

        return proc_constant( NODE_CN_FLOATING, LONG_MODIFIER, 1 );
    }

'{c_char_sequence}' {

        return proc_constant( NODE_CN_CHARACTER, NO_MODIFIER, 0 );
    }

L'{c_char_sequence}' {

        return proc_constant( NODE_CN_CHARACTER, WIDE_CHAR_MODIFIER, 1 );
    }

\"{s_char_sequence}\" {

        return proc_string_literal( NO_MODIFIER, 0 );
    }

L\"{s_char_sequence}\" {

        return proc_string_literal( WIDE_CHAR_MODIFIER, 1 );
    }

{whitespace}+     { proc_whitespace(); }

\n               { column = 0; line++; buffer_pos++; }

%%

static inline void move ( void ) {

    column += yyleng;
    buffer_pos += yyleng;
}

static void save ( void ) {

    yylval = new_tree_node();

    yylval->text = buffer + buffer_pos;
    yylval->text_length = yyleng;

    yylval->text_line_from = line;
    yylval->text_line_to = line;
    yylval->text_column_from = column;
    yylval->text_column_to = column + yyleng - 1;

    yylval->child_count = 0;

    yylval->prev_token = last_token;
    if ( last_token ) last_token->next_token = yylval;
    last_token = yylval;
}

static int proc_keyword ( int keyword ) {

    save();

    yylval->node_type = NODE_KEYWORD;
    yylval->node_subtype = keyword;

    move();

    return keyword;
}

static int proc_punctuator ( int punctuator ) {

    save();

    yylval->node_type = NODE_PUNCTUATOR;
    yylval->node_subtype = punctuator;

    move();

    return punctuator;
}

static int proc_identifier ( void ) {

/* TODO: test for TYPE_NAME */

    save();

    yylval->node_type = NODE_IDENTIFIER;

    move();

    return IDENTIFIER;
}

static int proc_constant ( int type, int modifiers, int suffix_len ) {

    save();

    yylval->node_type = NODE_CONSTANT;
    yylval->node_subtype = type;

/* TODO: do a proper type analysis */

    yylval->data_type = modifiers;

    move();

    return CONSTANT;
}

static int proc_string_literal ( int modifiers, int prefix_len ) {

    save();

    yylval->node_type = NODE_STRING_LITERAL;

/* TODO: do a proper type analysis */

    yylval->data_type = modifiers;

    move();

    return STRING_LITERAL;
}

static void proc_whitespace ( void ) {

    save();

    yylval->data_type = NODE_WHITESPACE;

    move();
}

static void proc_directive ( void ) {

    save();

    yylval->data_type = NODE_DIRECTIVE;

    move();
}

int yywrap ( void ) {

    return 1;
}

