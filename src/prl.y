%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token K_INT T_IDENTIFIER
%token T_EQUAL T_CONST
%token T_SEMICOLON T_PLUS T_MINUS  T_MULTIPLY T_DIVISION T_LPAREN T_RPAREN T_FUNC T_COMMA  T_RBRACE T_LBRACE T_NEWLINE T_EQUALEQUAL

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVISION

%start program

%%

program:
	   statement 
	   | statement program
;

statement:  declaration 
| assignment
| function 

declaration:  dynamicallyTypedDeclaration 
| staticallyTypedDeclaration 
|  constantDynamicallyTypedDeclaration 
| constantStaticallyTypedDeclaration
;

dynamicallyTypedDeclaration:
T_IDENTIFIER T_EQUAL expression 
| T_IDENTIFIER T_EQUAL expression 
;

staticallyTypedDeclaration:
type T_IDENTIFIER T_EQUAL expression 
| type T_IDENTIFIER T_EQUAL expression T_SEMICOLON
;

constantDynamicallyTypedDeclaration:
T_CONST T_IDENTIFIER T_EQUAL expression 
| T_CONST T_IDENTIFIER T_EQUAL expression T_SEMICOLON
;

constantStaticallyTypedDeclaration:
T_CONST type T_IDENTIFIER T_EQUAL expression 
| T_CONST type T_IDENTIFIER T_EQUAL expression T_SEMICOLON
;

assignment:
T_IDENTIFIER T_EQUAL expression 
| T_IDENTIFIER T_EQUAL expression T_SEMICOLON
;


expression: term
          | expression T_PLUS term
          | expression T_MINUS term
		  ;

term: factor
    | term T_MULTIPLY factor
    | term T_DIVISION factor
	;

factor: T_IDENTIFIER
      | NUM
      | T_LPAREN expression T_RPAREN
	  ;

NUM: T_INT | T_FLOAT

type: K_INT
;

function:
  arrowFunction 
  | simpleFunction 
  | simpleArrowFunction 
  | simpleSimpleFunction
  | lambdaFunction
  ;

  arrowFunction:
  T_IDENTIFIER T_EQUAL T_LPAREN parameters T_RPAREN T_LBRACE stmt_list T_RBRACE
  ;

  simpleFunction:
  T_FUNC T_IDENTIFIER T_LPAREN parameters T_RPAREN T_LBRACE stmt_list T_RBRACE
  ;

  simpleArrowFunction:
  ;

  simpleSimpleFunction:
  ;

   lambdaFunction:
   ;


   parameters:
    | T_IDENTIFIER
    | T_IDENTIFIER T_COMMA parameters
	;


stmt_list:
    stmt | stmt stmt_list

stmt:
    expr_stmt
    | if_stmt
    | return_stmt
	| program

expr_stmt:
    expr T_NEWLINE

if_stmt:
    'if' expr ':' T_NEWLINE suite |  'if' expr ':' T_NEWLINE suite  'else' ':' T_NEWLINE suite 

	call:
    


return_stmt:
    'return' expr T_NEWLINE

expr: call
    | lambda_expr

lambda_expr:
    'lambda' ':' expr

suite:
    T_IDENTIFIER stmt 

    binary_expression:
    expression T_PLUS expression
    | expression T_MINUS expression
    | expression T_MULTIPLY expression
    | expression T_DIVISION expression
    | expression T_EQUALEQUAL expression
    | expression '!=' expression
    | expression '<' expression
    | expression '>' expression
    | expression '<=' expression
    | expression '>=' expression
    | expression '&&' expression
    | expression '||' expression
    | expression '.' expression

%%

typedef struct AST_node {
    char* node_type;
    struct AST_node* left;
    struct AST_node* right;
    char* value;
} AST_node;


int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
