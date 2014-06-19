%{
#include <stdio.h>
#include <stdlib.h>
#include"listaBison.h"
#include <string.h>

//extern int contadorDeLinhas;
%}

%union {
   char * strval;
   int    intval;
}

%token <strval> T_NUMBER
%token <strval> T_STRING TEXTO  STR
%token AND OU IF ELSEIF DO THEN WHILE ELSE NOT VIRGULA
%token TERMINOU DECLARACAO FIMFUNC FUNCAO ESPERA EXECUTE PASSA
%token <strval> PRINT READ LOCAL 
%token MAIOR MENOR IGUAL SOMA SUBT MULT DIVIDE ATRIBUI LEFT_PAR RIGHT_PAR
%token  NUMERICAL



%start Input

%%

Input:
   /* Empty */
   | Input Line  
   ;

Line:
    Tab Comando NewLine
    ;

Tab:	
	{Tabulacao(tab);}
	;

Comando:
	Verbo
	| Estrutura
	| Fim
	;
	
Fim:
	{RemoveTab(&saida); tab--;} TERMINOU {qntEnd++; Inserir(&saida,"end", contadorDeLinhas);}
	;
	 
Estrutura:
	Function
	| If
	| SeNao
	| SeNaoSe
	| Enquanto
	;
	
Function:
	FUNCAO {qntFuncao++; qntEstru++; Inserir(&saida,"function ", contadorDeLinhas);} T_STRING { Inserir(&saida,$3, contadorDeLinhas); Inserir(&saida,"(", contadorDeLinhas);} Espera {Inserir(&saida,")", contadorDeLinhas);} {tab++;}
	;
	
Espera:
	ESPERA Espera_Argumentos
	|
	;

Espera_Argumentos:
	   STR T_STRING {Inserir(&saida,$2, contadorDeLinhas); InserirVariavel(&varDeclaradas, $2, "texto", "local");}
	|  NUMERICAL T_STRING {Inserir(&saida,$2, contadorDeLinhas); InserirVariavel(&varDeclaradas, $2, "numero", "local");}
	|  STR T_STRING {Inserir(&saida,$2, contadorDeLinhas); InserirVariavel(&varDeclaradas, $2, "texto", "local");} Virgula Espera_Argumentos
	|  NUMERICAL T_STRING {Inserir(&saida,$2, contadorDeLinhas); InserirVariavel(&varDeclaradas, $2, "numero", "local");} Virgula Espera_Argumentos
	;
	
ChamadaFunc:
	EXECUTE T_STRING { Inserir(&saida, $2, contadorDeLinhas); Inserir(&saida, "(", contadorDeLinhas);} Passa {Inserir(&saida,")", contadorDeLinhas);}
	;

Passa:
	
	| PASSA T_STRING {Inserir(&saida, $2, contadorDeLinhas); Inserir(&varUsadas, $2, contadorDeLinhas);}
	| PASSA Entrada

	;
If:
	IF { qntIf++; qntEstru++; Inserir(&saida, "if ", contadorDeLinhas);} Expressao {qntCondicao++;} Then {tab++;}
	;

SeNao:
	ELSE { RemoveTab(&saida); tab--; qntEstru++; qntEnd++; Inserir(&saida, "else ", contadorDeLinhas);} {tab++;}
	;

SeNaoSe:
	ELSEIF {RemoveTab(&saida); qntEnd++; qntIf++; qntEstru++; tab--;  Inserir(&saida, "elseif ", contadorDeLinhas);} Expressao {qntCondicao++;} Then {tab++;}
	;

Enquanto:
	WHILE {qntIf++; qntEstru++; Inserir(&saida, "while ", contadorDeLinhas);} Expressao {Inserir(&saida, " do ", contadorDeLinhas);} {qntCondicao++;} {tab++;} {qntThen++;}
	;

Then:
  	THEN {qntThen++; Inserir(&saida," then ", contadorDeLinhas);}
  	;
Verbo:
	Declare
	| Atribua
	| Imprima
	| Leia
	| ChamadaFunc
	//| Run
	;

	
Declare:
	DECLARACAO {Inserir(&saida,"local ", contadorDeLinhas);} Var_Declaracao
	;

Var_Declaracao:
	  STR T_STRING {Inserir(&saida,$2, contadorDeLinhas); InserirVariavel(&varDeclaradas, $2, "texto", "local"); qntDecl++;}
	| NUMERICAL T_STRING {Inserir(&saida,$2, contadorDeLinhas); InserirVariavel(&varDeclaradas, $2, "numero", "local"); qntDecl++;}
	| Var_Declaracao "," {Inserir(&saida, ", ", contadorDeLinhas);} T_STRING {Inserir(&saida,$4, contadorDeLinhas); InserirVariavel(&varDeclaradas, $4, "texto", "local"); qntDecl++;}
	| Var_Declaracao AND {Inserir(&saida, ", ", contadorDeLinhas);} T_STRING {Inserir(&saida,$4, contadorDeLinhas); InserirVariavel(&varDeclaradas, $4, "texto", "local"); qntDecl++;}
	;

Aux:
	Virgula
	| AND {Inserir(&saida, ", ", contadorDeLinhas);}
	;
	
Atribua:
	Variavel ATRIBUI {Inserir(&saida, " = ", contadorDeLinhas);} Expressao
	;

Expressao:
	Numero
	| Variavel
	| Numero Operador Expressao
	| Variavel Operador Expressao
	;



Imprima:
	PRINT { Inserir(&saida,"print(", contadorDeLinhas); } Entrada { Inserir(&saida,") ", contadorDeLinhas);}
	;

Entrada:
	TEXTO {Inserir(&saida,$1, contadorDeLinhas);}
       	| Expressao
	;

Leia:
	READ STR Variavel {Inserir(&saida," = io.read()", contadorDeLinhas);}
	| READ NUMERICAL Variavel {Inserir(&saida," = io.read(\"*number\")", contadorDeLinhas);}
	| Leia VIRGULA Leia_Complemento
	;
	
Leia_Complemento:
	STR  {Inserir(&saida,"\n", contadorDeLinhas);} Variavel {Inserir(&saida," = io.read()", contadorDeLinhas);}
	| NUMERICAL {Inserir(&saida,"\n", contadorDeLinhas);} Variavel {Inserir(&saida," = io.read(\"*number\")", contadorDeLinhas);}
	;


//Run:
//	EXECUTE T_STRING {Inserir(&saida, $2); Inserir(&saida,"(");} Argumento {Inserir(&saida,")");}
//	;

Variavel:
	T_STRING  { Inserir(&saida,$1, contadorDeLinhas); }
	;
	
Numero:
	T_NUMBER {Inserir(&saida,$1, contadorDeLinhas);}
   	;
   	
Operador:
  	MAIOR  {Inserir(&saida," > ", contadorDeLinhas);}
  	| MENOR {Inserir(&saida," < ", contadorDeLinhas);}
  	| IGUAL {Inserir(&saida," == ", contadorDeLinhas);}
  	| OU {Inserir(&saida," or ", contadorDeLinhas);}
  	| AND {Inserir(&saida," and ", contadorDeLinhas);}
	| NOT {Inserir(&saida," ~= ", contadorDeLinhas);}
  	| SOMA {Inserir(&saida, " + ", contadorDeLinhas);}
  	| SUBT {Inserir(&saida, " - ", contadorDeLinhas);} 
  	| MULT {Inserir(&saida, " * ", contadorDeLinhas);} 
  	| DIVIDE {Inserir(&saida, " / ", contadorDeLinhas);} 
  	| ATRIBUI {Inserir(&saida, " = ", contadorDeLinhas);} 
  	;

Virgula:
	VIRGULA {Inserir(&saida,", ", contadorDeLinhas);}
	;

NewLine:	
	{qntLinha++; PulaLinha();}
	;

%%

void main(void){
	saida = NULL;
	inic = NULL;
	varDeclaradas = NULL;
	varUsadas = NULL;
	erroSaida = NULL;
	yyparse();
	
	
	Compara();
	
	
	if(!(qntIf == qntCondicao && qntEstru == qntEnd && qntIf == qntThen))
	{
		correto = 0;
		Inserir(&erroSaida, "\n--Qnt de fim inferior a Qnt de Estruturas", contadorDeLinhas);
	}
		
	if(checkTipo == 1){
		correto = 0;
	}
	if(CheckVariaveis(varDeclaradas, varUsadas) == 0)
	{
		correto = 0;
		Inserir(&erroSaida, "\n--Variavel nao declarada foi usada", contadorDeLinhas);
	}

	if(correto)
		Imprime(saida);
	else
	{
		printf("\n--Ifs: %d\n", qntIf);
	printf("\n--Estruturas: %d\n", qntEstru);
	printf("\n--Ends: %d\n", qntEnd);
	printf("\n--Thens: %d\n", qntThen);
	printf("\n--Condicoes: %d\n", qntCondicao);
	
	printf("--Variaveis Declaradas: ");
	ImprimeVariavel(varDeclaradas);
	printf("\n--Variaveis Usadas: ");
	Imprime(varUsadas);
	printf("\n\n");
		ImprimeErro(erroSaida);
		printf("\n\n");
	}
	
}

yyerror(char *s){
	printf("Erro na linha: %d\n", contadorDeLinhas);
	printf("%s\n", s);
}

int yywrap(void) { return 1; }
