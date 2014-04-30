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
%token AND OU IF ELSEIF DO THEN WHILE ELSE
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
	|{tab--; } Tab Fim
	;
Corpo:
        |Comando
	|Estrutura
	;
Comando: Function
	| Declare
	| Atribui
       	| Print
       	| Read
       	| Estrutura 
	| Comando Comando
       	;
       	
Function:
	FUNCAO {qntFuncao++; qntEstru++; Inserir(&saida,"function ");} T_STRING { Inserir(&saida,$3); Inserir(&saida,"(");} {Inserir(&saida,")");} NewLine {tab++;} Tab Corpo Fim {Inserir(&saida,$3); Inserir(&saida, "()");} NewLine
	;
	
Declare:
	DECLARACAO {Inserir(&saida,"local ");} T_STRING {Inserir(&saida,$3); Inserir(&varDeclaradas, $3);} NewLine Tab
	;
	
Atribui:
	Variavel ATRIBUI {Inserir(&saida, " = ");} Condicao {qntCondicao--;} NewLine Tab
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
FimIf:
	TERMINOU {qntEnd++; Inserir(&saida,"end\n");}
       |ElseIf
       |Else
	;

ElseIf:
	ELSEIF {qntEnd++; Inserir(&saida, "elseif "); qntIf++; qntEstru++;} Condicao Then {tab++;} NewLine Tab Comando NewLine {tab--;} Tab FimIf
	;
Else:
	ELSE {qntEnd++; Inserir(&saida, "else"); qntIf++; qntEstru++; qntThen++; qntCondicao++;} {tab++;} NewLine Tab Comando NewLine {tab--;} Tab FimIf
  	;
	

Print:
   	PRINT { Inserir(&saida,"print("); } Entrada { Inserir(&saida,") ");} NewLine Tab
   	;
   	
Read:
	READ Variavel {Inserir(&saida," = io.read()");} NewLine Tab
	;
If:
	IF { qntIf++; qntEstru++;Inserir(&saida,"if ");} Condicao Then {tab++;} NewLine Tab Comando NewLine {tab--;} Tab FimIf
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
  	| SOMA {Inserir(&saida, " + ");}
  	| SUBT {Inserir(&saida, " - ");} 
  	| MULT {Inserir(&saida, " * ");} 
  	| DIVIDE {Inserir(&saida, " / ");} 
  	| ATRIBUI {Inserir(&saida, " = ");} 
  	;


%%

void main(void){
	saida = NULL;
	varDeclaradas = NULL;
	varUsadas = NULL;
	erroSaida = NULL;
	yyparse();
	
	printf("\n--Ifs: %d\n", qntIf);
	printf("\n--Estruturas: %d\n", qntEstru);
	printf("\n--Ends: %d\n", qntEnd);
	printf("\n--Thens: %d\n", qntThen);
	printf("\n--Condicoes: %d\n", qntCondicao);
	
	printf("--Variaveis Declaradas: ");
	Imprime(varDeclaradas);
	printf("\n--Variaveis Usadas: ");
	Imprime(varUsadas);
	printf("\n\n");
	
	
	if(!(qntIf == qntCondicao && qntEstru == qntEnd && qntIf == qntThen))
		correto = 0;
		
	
	if(CheckVariaveis(varDeclaradas, varUsadas) == 0)
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
