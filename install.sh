bison -dv parser.y
flex lexer.l
g++ parser.tab.c lex.yy.c -o main
