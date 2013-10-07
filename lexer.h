#ifndef __LEXER_H__
#define __LEXER_H__


int proc_keyword(int keyword);

int proc_punctuator(int punctuator);

int proc_identifier(void);

int proc_constant(int type, int modifiers, int modifiers_len);

int proc_string_literal(int modifiers, int modifiers_len);

void proc_whitespace(void);

void proc_directive(void);

void proc_unexpected_token(void);

void proc_new_line(void);


#endif /* __LEXER_H__ */
