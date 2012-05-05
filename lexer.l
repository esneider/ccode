%{

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "y.tab.h"

int line = 0, column = 0;

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

"break"			 { proc_keyword(); return 'brea'; }
"case"			 { proc_keyword(); return 'case'; }
"char"			 { proc_keyword(); return 'char'; }
"const"			 { proc_keyword(); return 'cons'; }
"continue"		 { proc_keyword(); return 'cont'; }
"default"		 { proc_keyword(); return 'defa'; }
"do"			 { proc_keyword(); return 'do'; }
"double"		 { proc_keyword(); return 'doub'; }
"else"			 { proc_keyword(); return 'else'; }
"enum"			 { proc_keyword(); return 'enum'; }
"extern"		 { proc_keyword(); return 'exte'; }
"float"			 { proc_keyword(); return 'floa'; }
"for"			 { proc_keyword(); return 'for'; }
"goto"			 { proc_keyword(); return 'goto'; }
"if"			 { proc_keyword(); return 'if'; }
"inline"		 { proc_keyword(); return 'inli'; }
"int"			 { proc_keyword(); return 'int'; }
"long"			 { proc_keyword(); return 'long'; }
"register"		 { proc_keyword(); return 'regi'; }
"restrict"		 { proc_keyword(); return 'rest'; }
"return"		 { proc_keyword(); return 'retu'; }
"short"			 { proc_keyword(); return 'shor'; }
"signed"		 { proc_keyword(); return 'sign'; }
"sizeof"		 { proc_keyword(); return 'size'; }
"static"		 { proc_keyword(); return 'stat'; }
"struct"		 { proc_keyword(); return 'stru'; }
"switch"		 { proc_keyword(); return 'swit'; }
"typedef"		 { proc_keyword(); return 'type'; }
"union"			 { proc_keyword(); return 'unio'; }
"unsigned"		 { proc_keyword(); return 'unsi'; }
"void"			 { proc_keyword(); return 'void'; }
"volatile"		 { proc_keyword(); return 'vola'; }
"while"			 { proc_keyword(); return 'whil'; }
"_Bool"			 { proc_keyword(); return '_Boo'; }
"_Complex"		 { proc_keyword(); return '_Com'; }
"_Imaginary"	 { proc_keyword(); return '_Ima'; }

"["		         { proc_punctuator(); return '['; }
"]"		         { proc_punctuator(); return ']'; }
"("		         { proc_punctuator(); return '('; }
")"		         { proc_punctuator(); return ')'; }
"{"			     { proc_punctuator(); return '{'; }
"}"			     { proc_punctuator(); return '}'; }
"."			     { proc_punctuator(); return '.'; }
"->"			 { proc_punctuator(); return '->'; }
"++"			 { proc_punctuator(); return '++'; }
"--"			 { proc_punctuator(); return '--'; }
"&"			     { proc_punctuator(); return '&'; }
"*"			     { proc_punctuator(); return '*'; }
"+"			     { proc_punctuator(); return '+'; }
"-"			     { proc_punctuator(); return '-'; }
"~"	   		     { proc_punctuator(); return '~'; }
"!"	    		 { proc_punctuator(); return '!'; }
"/"	    		 { proc_punctuator(); return '/'; }
"%"	    		 { proc_punctuator(); return '%'; }
"<<"			 { proc_punctuator(); return '<<'; }
">>"			 { proc_punctuator(); return '>>'; }
"<"	    		 { proc_punctuator(); return '<'; }
">"	    		 { proc_punctuator(); return '>'; }
"<="			 { proc_punctuator(); return '<='; }
">="			 { proc_punctuator(); return '>='; }
"=="			 { proc_punctuator(); return '=='; }
"!="			 { proc_punctuator(); return '!='; }
"^"	    		 { proc_punctuator(); return '^'; }
"|"		    	 { proc_punctuator(); return '|'; }
"&&"			 { proc_punctuator(); return '&&'; }
"||"			 { proc_punctuator(); return '||'; }
"?"		    	 { proc_punctuator(); return '?'; }
":"		    	 { proc_punctuator(); return ':'; }
";"		    	 { proc_punctuator(); return ';'; }
"..."			 { proc_punctuator(); return '...'; }
"="	    		 { proc_punctuator(); return '='; }
"*="			 { proc_punctuator(); return '*='; }
"/="			 { proc_punctuator(); return '/='; }
"%="			 { proc_punctuator(); return '%='; }
"+="			 { proc_punctuator(); return '+='; }
"-="			 { proc_punctuator(); return '-='; }
"<<="			 { proc_punctuator(); return '<<='; }
">>="			 { proc_punctuator(); return '>>='; }
"&="			 { proc_punctuator(); return '&='; }
"^="			 { proc_punctuator(); return '^='; }
"|="			 { proc_punctuator(); return '|='; }
","		    	 { proc_punctuator(); return ','; }
"#"		     	 { proc_punctuator(); return '#'; }
"##"		     { proc_punctuator(); return '##'; }
"<:"			 { proc_punctuator(); return '['; }
":>"			 { proc_punctuator(); return ']'; }
"<%"			 { proc_punctuator(); return '{'; }
"%>"			 { proc_punctuator(); return '}'; }
"%:"			 { proc_punctuator(); return '#'; }
"%:%:"			 { proc_punctuator(); return '##'; }

{identifier}     { proc_identifier(); return IDENTIFIER; }

[ \t\v\r\f]      { column++; }

\n               { column = 0; line++; }

.                { printf( "Parse error at line %d, column %d.\n", line, column ); yyterminate(); }

{dec_constant} {

        proc_integer_constant( true, 0, 0 );
        return CONSTANT;
    }

{dec_constant}{long_suffix} {

        proc_integer_constant( true, 1, LONG_MODIFIER );
        return CONSTANT;
    }

{dec_constant}{long_long_suffix} {

        proc_integer_constant( true, 1, LONG_LONG_MODIFIER );
        return CONSTANT;
    }

{dec_constant}{unsigned_suffix} {

        proc_integer_constant( true, 1, UNSIGNED_MODIFIER);
        return CONSTANT;
    }

{dec_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        proc_integer_constant( true, 2, UNSIGNED_MODIFIER | LONG_MODIFIER);
        return CONSTANT;
    }

{dec_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        proc_integer_constant( true, 2, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER );
        return CONSTANT;
    }

{uint_constant} {

        proc_integer_constant( false, 0, 0 );
        return CONSTANT;
    }

{uint_constant}{long_suffix} {

        proc_integer_constant( false, 1, LONG_MODIFIER );
        return CONSTANT;
    }

{uint_constant}{long_long_suffix} {

        proc_integer_constant( false, 1, LONG_LONG_MODIFIER );
        return CONSTANT;
    }

{uint_constant}{unsigned_suffix} {

        proc_integer_constant( false, 1, UNSIGNED_MODIFIER );
        return CONSTANT;
    }

{uint_constant}({unsigned_suffix}{long_suffix}|{long_suffix}{unsigned_suffix}) {

        proc_integer_constant( false, 2, UNSIGNED_MODIFIER | LONG_MODIFIER );
        return CONSTANT;
    }

{uint_constant}({unsigned_suffix}{long_long_suffix}|{long_long_suffix}{unsigned_suffix}) {

        proc_integer_constant( false, 2, UNSIGNED_MODIFIER | LONG_LONG_MODIFIER );
        return CONSTANT;
    }

{floating_constant} {

        proc_floating_constant( 0, 0 );
        return CONSTANT;
    }

{floating_constant}{float_suffix} {

        proc_floating_constant( 1, FLOAT_MODIFIER );
        return CONSTANT;
    }

{floating_constant}{long_suffix} {

        proc_floating_constant( 1, LONG_MODIFIER );
        return CONSTANT;
    }

'{c_char_sequence}' {

        proc_char_constant( 0, 0 );
        return CONSTANT;
    }

L'{c_char_sequence}' {

        proc_char_constant( 1, WIDE_CHAR_MODIFIER );
        return CONSTANT;
    }

"{s_char_sequence}" {

        proc_string_literal( 0, 0 );
        return STRING_LITERAL;
    }

L"{s_char_sequence}" {

        proc_string_literal( 1, WIDE_CHAR_MODIFIER );
        return STRING_LITERAL;
    }

%%

static inline void move ( void ) {

    column += yyleng;
}

static void proc_keyword ( void ) {

    move();
}

static void proc_punctuator ( void ) {

    move();
}

static void proc_identifier ( void ) {

    move();
}

static void proc_integer_constant ( bool is_signed, int suffix_len, int modifiers ) {

    move();
}

static void proc_floating_constant ( int suffix_len, int modifiers ) {

    move();
}

static void proc_char_constant ( int prefix_len, int modifiers ) {

    move();
}

static void proc_string_literal ( int prefix_len, int modifiers ) {

    move();
}

int yywrap ( void ) {

    return 0;
}

