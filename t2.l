%option yylineno
%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
    int cont=0;
    void parenteses();
%}

VAR [a-zA-Z][a-zA-Z0-9]*
NUM [0-9]

%%

{NUM}+"."{NUM}	{
                yylval = atoi(yytext);
		cont+=yyleng;
                return FLOAT;
		}

{NUM}+		{ 
		yylval = atoi(yytext);
	  	cont+=yyleng; return INTEGER; 
		}

[-+()=/*<>]	{ 
		cont+=yyleng; return *yytext; 
		}

true		{ 
		cont += 4; return TRUE; 
		}

false		{ 
		cont += 5; return FALSE; 
		}

OR		{ 
		cont += 2; return OR; 
		}

AND		{ 
		cont += 3; return AND; 
		}

NOT		{ 
		cont += 3; return NOT; 
		}

{VAR}		{
		yylval = *yytext - 'a';
		cont+=yyleng;
                return VARIABLE; 
		}

"<="		{ 
		cont += 2; return LE; 
		}

"=="		{ 
		cont += 2; return EQ; 
		}

">="		{ 
		cont += 2; return GE; 
		}

"<>"		{ 
		cont += 2; return NE; 
		}

[\t]		{ 
		cont += 4; 
		}

[\n]		{
		cont = 0; return *yytext;
		}

[ ]		{ 
		cont++; 
		} 

. { printf("ERRO: token inválido\n"); exit(-1);}

%%

void yyerror(char *s) {
    printf("Error line: %d column: %d\n", yylineno, cont);
    exit(-1);
}

int yywrap(void) {
    return 1;
}

void parenteses(){
  if(cont!=0) printf("ERRO: parênteses desbalanceados.\n");
  cont = 0;
}
