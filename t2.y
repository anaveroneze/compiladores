%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);
    int sym[26];
%}

%token INTEGER FLOAT VARIABLE
%token TRUE FALSE

%left '+' '-'
%left '*' '/'
%left NEG
%left LE GE EQ NE '<' '>'
%left AND OR NOT

%%

program:
        program statement '\n'
	| program error '\n'
        | /* NULL */
        ;

statement:
        logico                      { printf("pertence: %d\n", $1); }     
	| expression                      { printf("pertence: %d\n", $1); } 
        | VARIABLE '=' expression       { sym[$1] = $3; }
        ;

expression:
        INTEGER
	| FLOAT
        | VARIABLE                      { $$ = sym[$1]; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { $$ = $1 / $3; }
	| '-' expression %prec NEG      { $$ = -$2; }
        | '(' expression ')'            { $$ = $2; }
        ;

logico:
	TRUE 			{$$ = 1; }
	|FALSE			{$$ = 0; }
	| NOT logico 	{$$ = !$2;}
	| logico OR logico { $$ = $1 || $3; }
	| logico AND logico { $$ = $1 && $3; }
        | logico '>' logico     { $$ = $1 > $3; }
        | logico '<' logico     { $$ = $1 < $3; }
        | logico GE logico     { $$ = $1 >= $3; }
        | logico LE logico     { $$ = $1 <= $3; }
        | logico EQ logico     { $$ = $1 == $3; }
        | logico NE logico     { $$ = $1 != $3; }
        | expression '>' expression     { $$ = $1 > $3; }
        | expression '<' expression     { $$ = $1 < $3; }
        | expression GE expression     { $$ = $1 >= $3; }
        | expression LE expression     { $$ = $1 <= $3; }
        | expression EQ expression     { $$ = $1 == $3; }
        | expression NE expression     { $$ = $1 != $3; }
        | '(' logico ')'            { $$ = $2; }
	;

%%

int main(void) {
    yyparse();
}
