parser: lex.yy.c y.tab.c
	gcc -o parser y.tab.c
y.tab.c: CS315_S24_Team12.y
	yacc CS315_S24_Team12.y
lex.yy.c: CS315_S24_Team12.l
	lex CS315_S24_Team12.l