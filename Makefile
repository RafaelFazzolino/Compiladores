all: removeold compilabison compilaflex compilac exportalua

removeold:
	rm -rf programa output.lua
compilabison: bison.y
	bison -d -obison.c bison.y
compilaflex: aula01.l
	flex aula01.l
compilac: bison.tab.c lex.yy.c
	gcc bison.c lex.yy.c -o programa
exportalua: 
	cat input.portugol | ./programa > output.lua
