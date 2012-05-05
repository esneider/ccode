#ifndef __TREE_TERMINALS_H__
#define __TREE_TERMINALS_H__


enum constant_type {

    INT_CONSTANT, UINT_CONSTANT, FLOAT_CONSTANT, CHAR_CONSTANT
};


enum modifiers {

    UNSIGNED_MODIFIER  = 1,
    LONG_MODIFIER      = 2,
    LONG_LONG_MODIFIER = 4,
    WIDE_CHAR_MODIFIER = 8,
    FLOAT_MODIFIER     = 16
};


struct token {

    int line, column, textlen;

    char *text;
};


struct keyword {

    struct token token;

    int keyword;
};


struct punctuator {

    struct token token;

    int punctuator;
};


struct identifier {

    struct token token;
};


struct string_literal {

    struct token token;

    int modifiers;
};


struct constant {

    struct token token;

    int modifiers, type;
};


#endif /* __TREE_TERMINALS_H__ */

