#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 30

int qntFuncao = 0;
int qntLinha = 0;
int qntIf = 0;
int qntEstru = 0;
int qntCondicao = 0;
int qntThen = 0;
int qntEnd = 0;
int correto = 1;
int tab = 0;
int nVariavel = 0;

typedef struct fila
{
    char string[MAX];
    struct fila * proximo;
}Fila;

Fila * saida;
Fila * varDeclaradas;
Fila * varUsadas;
Fila * erroSaida;

Fila * Add(char nome[MAX])
{
    Fila * add = (Fila*) malloc(sizeof(Fila));
    strcpy(add->string, nome);
    add->proximo == NULL;

    return add;
}

void Inserir(Fila ** temp, char nome[MAX])
{
	Fila * aux = Add(nome);
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

void Imprime(Fila * temp)
{
	Fila * aux = temp;
	while(aux != NULL)
	{
		printf("%s", aux->string);
		aux= aux->proximo;
	}

}

void PulaLinha()
{
	Inserir(&saida,"\n");	
}

void Tabulacao(int tab)
{
	int i = 0;
	for( i=0; i<tab; i++)
		Inserir(&saida,"\t");
}

int CheckVariaveis(Fila * declaradas, Fila * usadas)
{
	Fila * aux;
	int declarou = 0;
	if(usadas == NULL)
		return 1;
		
		
	while(usadas!= NULL)
	{
		aux = declaradas;
		declarou = 0;
		while(aux != NULL)
		{
			if(strcmp(usadas->string, aux->string) == 0)
				declarou = 1;
				
			
			aux = aux->proximo;
		}
		if(declarou == 0)
		{
			Inserir(&erroSaida, "Variavel ");
			Inserir(&erroSaida, usadas->string);
			Inserir(&erroSaida, " nao declarada!");
			return 0;	
		}
		usadas = usadas->proximo;
	}
	
	return 1;	
}
