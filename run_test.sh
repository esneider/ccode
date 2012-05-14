#!/bin/sh
bison -d parser.y && flex lexer.l && cd test/ && gcc -I. -I.. -ly -g parser_test.c ../*.c && ./a.out && cd ..
rm -rf *.tab.* *.yy.* test/a.out*
