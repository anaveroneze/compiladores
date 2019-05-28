    /* calculator #1 */
%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

VAR [a-zA-Z][a-zA-Z0-9]*
NUM [0-9]

%%

[a-z]       {
                yylval = *yytext - 'a';
                return VARIABLE;
                }

{NUM}+      {
                yylval = atoi(yytext);
                return INTEGER;
            }

[-+()=/*<>\n]     { return *yytext; }

true	return TRUE;
false	return FALSE;
OR	return OR;
AND	return AND;
NOT	return NOT;

"<="  return LE;
"=="   return EQ;
">="  return GE;
"<>"  return NE;

[ \t]   ;
. yyerror("ERRO: token inválido ");

%%

int yywrap(void) {
    return 1;
}
