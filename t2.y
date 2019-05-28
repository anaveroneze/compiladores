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
%left LE GE EQ NE '<' '>'
%left AND OR NOT
%nonassoc UMINUS

%%

program:
        program statement '\n'
        | /* NULL */
        ;

statement:
        expression                      { printf("%d\n", $1); }                  
        | VARIABLE expression       { sym[$1] = $2; }
        ;

expression:
        INTEGER
        | VARIABLE                      { $$ = sym[$1]; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { $$ = $1 / $3; }
        | expression '>' expression     { $$ = $1 > $3; }
        | expression '<' expression     { $$ = $1 < $3; }
        | expression GE expression     { $$ = $1 >= $3; }
        | expression LE expression     { $$ = $1 <= $3; }
        | expression EQ expression     { $$ = $1 == $3; }
        | expression NE expression     { $$ = $1 != $3; }
	| logico
        | '(' expression ')'            { $$ = $2; }
        ;

logico:
	TRUE 			{$$ = 1; }
	|FALSE			{$$ = 0; }
	| NOT expression 	{$$ = !$2;}
	| expression OR expression { $$ = $1 || $3; }
	| expression AND expression { $$ = $1 && $3; }
	;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
