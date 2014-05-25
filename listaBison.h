#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 500

int qntFuncao = 0;
int qntLinha = 0;
int qntIf = 0;
int qntEstru = 0;
int qntCondicao = 0;
int qntThen = 0;
int qntEnd = 0;
int qntDecl = 0;
int correto = 1;
int tab = 0;
int nVariavel = 0;
int checkTipo = 0;

extern int contadorDeLinhas;


typedef struct fila
{
    char string[MAX];
    int linhaPort;
    struct fila * proximo;
}Fila;

typedef struct variavel
{
    char nome[MAX];
    char tipo[MAX];
    char escopo[MAX];
    struct variavel * proximo;
}Variavel;

Fila * saida;
Fila * inic;
Variavel * varDeclaradas;
Fila * varUsadas;
Fila * Comparar;
Fila * erroSaida;

Fila * Add(char nome[MAX], int linhaPort)
{
    Fila * add = (Fila*) malloc(sizeof(Fila));
    strcpy(add->string, nome);
    add->linhaPort = linhaPort;
    add->proximo == NULL;

    return add;
}

Variavel * AddVariavel(char nome[MAX], char tipo[MAX], char escopo[MAX])
{
    Variavel * add = (Variavel*) malloc(sizeof(Variavel));
    strcpy(add->nome, nome);
    strcpy(add->tipo, tipo);
    strcpy(add->escopo, escopo);
    add->proximo == NULL;

    return add;
}

void Inserir(Fila ** temp, char nome[MAX], int linhaPort)
{
	Fila * aux = Add(nome, linhaPort);
	Fila * head = *temp;
	int igual = 0;
	if(*temp == NULL)
	{
		*temp = aux;
	}
	else
	{
		struct fila * aux2 = *temp;
		while(aux2->proximo != NULL)
		{
			if((&(*head) == varUsadas) && !strcmp(aux->string, aux2->string))
				igual = 1;
			aux2 = aux2->proximo;
		}
		if((&(*head) == varUsadas) && !strcmp(aux->string, aux2->string))
				igual = 1;
		if(!igual)
			aux2->proximo = aux;
	}
}

void Compara(){
	Variavel * temp;
	temp = varDeclaradas;
	Fila * tudo;
	tudo = saida;
	char tipo[100][10];
	int i=0, k=0;
	Variavel * aux = temp;
	Variavel * aux2 = temp;
	int linha = 0;
	while(tudo != NULL){
		if(strcmp(tudo->string, "if ") == 0){ /*IF para achar a comparação de duas variáveis de tipos diferentes*/		
			linha = tudo->linhaPort;
			while(strcmp(tudo->string, " then ") != 0){
				aux = temp;
				while(aux != NULL){
					if(strcmp( aux->nome, tudo->string)==0){
						strcpy(tipo[i], aux->tipo);
						i++;
					}
					aux = aux->proximo;
				}
				tudo = tudo->proximo;
				
			}
		}
		aux = temp;
		while(aux != NULL){
			if(strcmp( aux->nome, tudo->string)==0){ /*IF para achar atribuição de variaveis de tipos diferentes*/
				linha = tudo->linhaPort;
				if(strcmp(tudo->proximo->string, " = ")==0){
					strcpy(tipo[i], aux->tipo);
					i++;
					while(aux2 != NULL){
						if(strcmp( aux2->nome, tudo->proximo->proximo->string)==0){
							strcpy(tipo[i], aux2->tipo);
							i++;
						}
					aux2 = aux2->proximo;
					}
					aux2 = temp;
					
				}
			}			
			aux = aux->proximo;
		}
	tudo = tudo->proximo;
		
	}
	for(k=0 ; k < i-1 ; k++){
		printf("--k: %s, k+1: %s\n", tipo[k], tipo[k+1]);
		if(strcmp(tipo[k], tipo[k+1]) != 0){
			checkTipo = 1;
		}
	}

	if(checkTipo)
		Inserir(&erroSaida, " variaveis de tipos diferentes\n", linha);
}
			
	
		
	

void InserirVariavel(Variavel ** temp, char nome[MAX], char tipo[MAX], char escopo[MAX])
{
	Variavel * aux = AddVariavel(nome, tipo, escopo);
	Variavel * head = *temp;
	if(*temp == NULL)
	{
		*temp = aux;
	}
	else
	{
		struct variavel * aux2 = *temp;
		while(aux2->proximo != NULL)
		{
			
			aux2 = aux2->proximo;
		}
		
			aux2->proximo = aux;
	}
}

void Imprime(Fila * temp)
{
	Fila * aux = temp;
	while(aux != NULL)
	{
		printf("%s", aux->string);
		aux= aux->proximo;
	}

}

void ImprimeErro(Fila * temp)
{
	
	while(temp != NULL)
	{
		printf("Erro na linha %d", temp->linhaPort);
		printf("%s", temp->string);
		temp = temp->proximo;
	}

}

void ImprimeVariavel(Variavel * temp)
{
	Variavel * aux = temp;
	while(aux != NULL)
	{
		printf("%s ", aux->nome);
		aux= aux->proximo;
	}

}

void PulaLinha()
{
	Inserir(&saida,"\n", contadorDeLinhas);	
}

void Tabulacao(int tab)
{
	int i = 0;
	for( i=0; i<tab; i++)
		Inserir(&saida,"\t", contadorDeLinhas);
}

void RemoveTab(Fila ** temp)
{
	Fila * lista = *temp;
	while(lista->proximo->proximo != NULL)
	{
		lista = lista->proximo;
	}
	if(strcmp(lista->proximo->string, "\t") == 0 )
	{
		lista->proximo = NULL;
	}
}

/*
void InseriInicializa()
{
	Fila * temp = inic;
	
	while(temp != NULL)
	{
		Inserir(&saida, temp->string, contadorDeLinhas);
		temp = temp->proximo;
	}
}

void Inicializa(char * tipo, int qnt)
{
	char temp[5];
	
	if(strcmp(tipo, "numer") == 0)
	{
		strcpy(temp, "0");
	}
	else
		strcpy(temp, "\"\"");
		
	
	while(qnt)
	{
		if(inic != NULL)
			Inserir(&inic, ", ");
		Inserir(&inic, temp); 
		
		qnt--;
	}
}
*/
int CheckVariaveis(Variavel * declaradas, Fila * usadas)
{
	Variavel * aux;
	int declarou = 0;
	if(usadas == NULL)
		return 1;
		
		
	while(usadas!= NULL)
	{
		aux = declaradas;
		declarou = 0;
		while(aux != NULL)
		{
			if(strcmp(usadas->string, aux->nome) == 0)
				declarou = 1;
				
			
			aux = aux->proximo;
		}
		if(declarou == 0)
		{
			Inserir(&erroSaida, "Variavel ", contadorDeLinhas);
			Inserir(&erroSaida, usadas->string, contadorDeLinhas);
			Inserir(&erroSaida, " nao declarada!", contadorDeLinhas);
			return 0;	
		}
		usadas = usadas->proximo;
	}
	
	return 1;	
}
