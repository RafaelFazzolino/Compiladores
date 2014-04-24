all: compilabison compilaflex final
compilabison: bison.y
	bison -d -obison.c bison.y
compilaflex: aula01.l
	flex aula01.l
final: bison.tab.c lex.yy.c
	gcc bison.c lex.yy.c -o programa
