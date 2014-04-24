%{
#include <stdio.h>
#include <stdlib.h>
#include "listaBison.h"
#include <string.h>



%}

%union {
   char * strval;
   int    intval;
}

%token <strval> T_NUMBER
%token <strval> T_STRING TEXTO
%token AND OU IF ELSEIF DO THEN WHILE
%token TERMINOU DECLARACAO FIMFUNC FUNCAO
%token <strval> PRINT READ LOCAL 
%token MAIOR MENOR IGUAL SOMA SUBT MULT DIVIDE ATRIBUI

%start Input

%%

Input:
   /* Empty */
   | Input Line  
   ;

Line:
    Tab Comando NewLine Final
    ;

Tab:	{Tabulacao(tab);}
	;

NewLine:	{qntLinha++; PulaLinha();}
	| "\n"	{qntLinha++; PulaLinha();}
	;

Final:
	|{tab--; } Tab Fim FIMFUNC 
	;

Comando: Function
	| Declare
       	| Print
       	| Read
       	| Estrutura 
       	;
       	
Function:
	FUNCAO {qntFuncao++; qntEstru++; Inserir(&saida,"Function ");} T_STRING { Inserir(&saida,$3); Inserir(&saida,"(");} {Inserir(&saida,")");} {tab++;}
	;
	
Declare:
	DECLARACAO {Inserir(&saida,"local ");} T_STRING {Inserir(&saida,$3); Inserir(&varDeclaradas, $3);} 
	| Declare {Inserir(&saida, ", ");} T_STRING {Inserir(&saida,$3); Inserir(&varDeclaradas, $3);} 
	;
       
Estrutura:
	If
	;

Entrada: TEXTO {Inserir(&saida,$1);}
       	| Variavel
       	;

Fim:
       	TERMINOU {qntEnd++; Inserir(&saida,"end\n");}
       	;


Print:
   	PRINT { Inserir(&saida,"print("); } Entrada { Inserir(&saida,") ");}
   	;
   	
Read:
	READ Variavel {Inserir(&saida," = io.read()");} 

If:
	IF { qntIf++; qntEstru++;Inserir(&saida,"if ");} Condicao Then {tab++;} NewLine Tab Comando NewLine {tab--;} Tab Fim
  	;

Condicao:
  	Numero {qntCondicao++;}
	| Variavel {qntCondicao++;}
  	| Condicao Operador Condicao {qntCondicao--;}
  	
  	;

Then:
  	THEN {qntThen++; Inserir(&saida," then ");}
  	;

Variavel:
	T_STRING  { Inserir(&saida,$1); } {Inserir(&varUsadas, $1);}
	;

Numero:
	T_NUMBER { Inserir(&saida,$1); }
   	;

Operador:
  	MAIOR  {Inserir(&saida," > ");}
  	| MENOR {Inserir(&saida," < ");}
  	| IGUAL {Inserir(&saida," == ");}
  	| OU {Inserir(&saida," or ");}
  	| AND {Inserir(&saida," and ");}
  	;


%%

void main(void){
	saida = NULL;
	varDeclaradas = NULL;
	varUsadas = NULL;
	erroSaida = NULL;
	yyparse();
	printf("\nIfs: %d\n", qntIf);
	printf("\nEstruturas: %d\n", qntEstru);
	printf("\nEnds: %d\n", qntEnd);
	printf("\nThens: %d\n", qntThen);
	printf("\nCondicoes: %d\n", qntCondicao);
	
	printf("Variaveis Declaradas: ");
	Imprime(varDeclaradas);
	printf("\nVariaveis Usadas: ");
	Imprime(varUsadas);
	printf("\n\n");
	
	if(!(qntIf == qntCondicao && qntEstru == qntEnd && qntIf == qntThen))
		correto = 0;
		
	
	if(!CheckVariaveis(varDeclaradas, varUsadas))
		correto = 0;
	
	if(correto)
		Imprime(saida);
	else
	{
		Imprime(erroSaida);
		printf("\n\n");
	}
	
}

yyerror(char *s){
	printf("%s\n", s);
}

int yywrap(void) { return 1; }
