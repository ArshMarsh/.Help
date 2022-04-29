parser:lex.yy.c	y.tab.c
	gcc lex.yy.c y.tab.c -o parser

y.tab.c:CS315s22_team11.y 
	yacc -d CS315s22_team11.y

lex.yy.c:CS315s22_team11.l
	lex CS315s22_team11.l