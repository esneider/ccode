
kw_auto               "auto"
kw_break              "break"
kw_case               "case"
kw_char               "char"
kw_const              "const"
kw_continue           "continue"
kw_default            "default"
kw_do                 "do"
kw_double             "double"
kw_else               "else"
kw_enum               "enum"
kw_extern             "extern"
kw_float              "float"
kw_for                "for"
kw_goto               "goto"
kw_if                 "if"
kw_inline             "inline"
kw_int                "int"
kw_long               "long"
kw_register           "register"
kw_restrict           "restrict"
kw_return             "return"
kw_short              "short"
kw_signed             "signed"
kw_sizeof             "sizeof"
kw_static             "static"
kw_struct             "struct"
kw_switch             "switch"
kw_typedef            "typedef"
kw_union              "union"
kw_unsigned           "unsigned"
kw_void               "void"
kw_volatile           "volatile"
kw_while              "while"
kw__Bool              "_Bool"
kw__Complex           "_Complex"
kw__Imaginary         "_Imaginary"

keyword               ({kw_auto}|{kw_break}|{kw_case}|{kw_char}|{kw_const}|{kw_continue}|{kw_default}|{kw_do}|{kw_double}|{kw_else}|{kw_enum}|{kw_extern}|{kw_float}|{kw_for}|{kw_goto}|{kw_if}|{kw_inline}|{kw_int}|{kw_long}|{kw_register}|{kw_restrict}|{kw_return}|{kw_short}|{kw_signed}|{kw_sizeof}|{kw_static}|{kw_struct}|{kw_switch}|{kw_typedef}|{kw_union}|{kw_unsigned}|{kw_void}|{kw_volatile}|{kw_while}|{kw__Bool}|{kw__Complex}|{kw__Imaginary})

nondigit              [_a-zA-Z]
digit                 [0-9]
nonzero_digit         [1-9]
oct_digit             [0-7]
hex_digit             [0-9a-fA-F]

hex_prefix            (0x|0X)
unsigned_suffix       (u|Ui)
long_suffix           (l|L)
long_long_suffix      (ll|LL)
floating_suffix       (f|l|F|L)
integer_suffix        ({unsigned_suffix}({long_suffix}|{long_long_suffix})?|({long_suffix|long_long_suffix}){unsigned_suffix}?)

sign                  (\-|\+)
digit_sequence        {digit}+
hex_digit_sequence    {hex_digit}+
char_sequence         ([^'\\\n]|\\[^\n])+

hex_quad              {hex_digit}{4}
universal_char_name   (\\u{hex_quad}|\\U{hex_quad}{2})

identifier_nondigit   ({nondigit}|{universal_char_name})
identifier            {identifier_nondigit}({identifier_nondigit}|{digit})*

dec_constant          {nonzero_digit}{digit}*
oct_constant          0{oct_digit}*
hex_constant          {hex_prefix}{hex_digit}+
integer_constant      ({dec_constant}|{oct_constant}|{hex_constant}){integer_suffix}?

frac_constant         ({digit_sequence}?\.{digit_sequence}|{digit_sequence}\.)
exponent_part         (e|E){sign}?{digit_sequence}
dec_floating_constant ({frac_constant}{exponent_part}?|{digit_sequence}{exponent_part}){floating_suffix}?

hex_frac_constant     ({hex_digit_sequence}?\.{hex_digit_sequence}|{hex_digit_sequence}\.)
bin_exponent_part     (p|P){sign}?{digit_sequence}
hex_floating_constant {hex_prefix}({hex_frac_constant}|{hex_digit_sequence}){bin_exponent_part}{floating_suffix}?

floating_constant     ({dec_floating_constant}|{hex_floating_constant})
character_constant    L?'{char_sequence}'
constant              ({integer_constant}|{floating_constant}|{character_constant})

string_literal        L?\"{char_sequence}\"

pn_left_square_bracket      "["
pn_right_square_bracket     "]"
pn_left_round_bracket       "("
pn_right_round_bracket      ")"
pn_left_curly_bracket       "{"
pn_right_curly_bracket      "}"
pn_member                   "."
pn_member_pointer           "->"
pn_increment                "++"
pn_decrement                "--"
pn_bitwise_and              "&"
pn_multiplication           "*"
pn_plus                     "+"
pn_minus                    "-"
pn_bitwise_complement       "~"
pn_not                      "!"
pn_division                 "/"
pn_modulus                  "%"
pn_left_shift               "<<"
pn_right_shift              ">>"
pn_less                     "<"
pn_more                     ">"
pn_less_equal               "<="
pn_more_equal               ">="
pn_equal                    "=="
pn_not_equal                "!="
pn_bitwise_xor              "^"
pn_bitwise_or               "|"
pn_and                      "&&"
pn_or                       "||"
pn_conditional              "?"
pn_colon                    ":"
pn_semicolon                ";"
pn_ellipsis                 "..."
pn_assign                   "="
pn_multiplication_assign    "*="
pn_division_assign          "/="
pn_modulus_assign           "%="
pn_plus_assign              "+="
pn_minus_assign             "-="
pn_left_shift_assign        "<<="
pn_right_shift_assign       ">>="
pn_bitwise_and_assign       "&="
pn_bitwise_xor_assign       "^="
pn_bitwise_or_assign        "|="
pn_comma                    ","
pn_hash                     "#"
pn_double_hash              "##"
pn_left_square_bracket_alt  "<:"
pn_right_square_bracket_alt ":>"
pn_left_curly_bracket_alt   "<%"
pn_right_curly_bracket_alt  "%>"
pn_hash_alt                 "%:"
pn_double_hash_alt          "%:%:"

punctuator            ({pn_left_square_bracket}|{pn_right_square_bracket}|{pn_left_round_bracket}|{pn_right_round_bracket}|{pn_left_curly_bracket}|{pn_right_curly_bracket}|{pn_member}|{pn_member_pointer}|{pn_increment}|{pn_decrement}|{pn_bitwise_and}|{pn_multiplication}|{pn_plus}|{pn_minus}|{pn_bitwise_complement}|{pn_not}|{pn_division}|{pn_modulus}|{pn_left_shift}|{pn_right_shift}|{pn_less}|{pn_more}|{pn_less_equal}|{pn_more_equal}|{pn_equal}|{pn_not_equal}|{pn_bitwise_xor}|{pn_bitwise_or}|{pn_and}|{pn_or}|{pn_conditional}|{pn_colon}|{pn_semicolon}|{pn_ellipsis}|{pn_assign}|{pn_multiplication_assign}|{pn_division_assign}|{pn_modulus_assign}|{pn_plus_assign}|{pn_minus_assign}|{pn_left_shift_assign}|{pn_right_shift_assign}|{pn_bitwise_and_assign}|{pn_bitwise_xor_assign}|{pn_bitwise_or_assign}|{pn_comma}|{pn_hash}|{pn_double_hash}|{pn_left_square_bracket_alt}|{pn_right_square_bracket_alt}|{pn_left_curly_bracket_alt}|{pn_right_curly_bracket_alt}|{pn_hash_alt}|{pn_double_hash_alt})

token                 ({keyword}|{identifier}|{constant}|{string_literal}|{punctuator})

%%

%%

