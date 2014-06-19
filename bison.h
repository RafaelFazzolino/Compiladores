/* A Bison parser, made by GNU Bison 2.5.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_NUMBER = 258,
     T_STRING = 259,
     TEXTO = 260,
     STR = 261,
     AND = 262,
     OU = 263,
     IF = 264,
     ELSEIF = 265,
     DO = 266,
     THEN = 267,
     WHILE = 268,
     ELSE = 269,
     NOT = 270,
     VIRGULA = 271,
     TERMINOU = 272,
     DECLARACAO = 273,
     FIMFUNC = 274,
     FUNCAO = 275,
     ESPERA = 276,
     EXECUTE = 277,
     PASSA = 278,
     PRINT = 279,
     READ = 280,
     LOCAL = 281,
     MAIOR = 282,
     MENOR = 283,
     IGUAL = 284,
     SOMA = 285,
     SUBT = 286,
     MULT = 287,
     DIVIDE = 288,
     ATRIBUI = 289,
     LEFT_PAR = 290,
     RIGHT_PAR = 291,
     NUMERICAL = 292
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 2068 of yacc.c  */
#line 10 "bison.y"

   char * strval;
   int    intval;



/* Line 2068 of yacc.c  */
#line 94 "bison.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


