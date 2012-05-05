#ifndef __TREE_H__
#define __TREE_H__


enum constant_type {

    INT_CONSTANT, FLOAT_CONSTANT, CHAR_CONSTANT
};


enum modifiers {

    UNSIGNED_MODIFIER, LONG_MODIFIER, LONG_LONG_MODIFIER, WIDE_CHAR_MODIFIER, FLOAT_MODIFIER
};


struct identifier {

    int line, column, textlen;

    char *text;
};


struct string_literal {

    int line, column, textlen;

    char *text;

    enum modifiers modifiers;
};


struct constant {

    int line, column, textlen;

    char *text;

    enum constant_type type;

    enum modifiers modifiers;
};


#endif /* __TREE_H__ */

