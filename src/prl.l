%option noyywrap


%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "prl.tab.h"


void yyerror(const char* s);

#define YY_USER_ACTION yylineno++;

int lineno = 1;

int usingMath = 0;


#define T_BOOL 1
#define T_FLOAT_K 2
#define T_STRING_K 3
#define T_ENUM 4
#define T_STRUCT 5
#define T_ARRAY 6
#define T_NULLP 7
#define T_IF 8
#define T_ELSE 9
#define T_ELSEIF 10
#define T_FUNC 11
#define T_OUTPUT 12
#define T_INPUT 13
#define T_PLUS 14
#define T_MINUS 15
#define T_MULTIPLY 16
#define T_DIVISION 17
#define T_EQUALEQUAL 18
#define T_NOTEQUAL 19
#define T_LESSTHAN 20
#define T_MORETHAN 21
#define T_CONST 22
#define T_SEMICOLON 23
#define T_EQUAL 24
#define T_IMPORT 25
#define T_TRUE 26
#define T_FALSE 27
#define T_AND 28
#define T_OR 29
#define T_XOR 30
#define T_WHILE 31
#define T_FOR 32
#define T_ARROW 33
#define T_LESSOREQUAL 34
#define T_GREATEROREQUAL 35
#define T_RPAREN 36
#define T_RBRACE 37
#define T_RBRACKET 38
#define T_LBRACE 39
#define T_LPAREN 40
#define T_LBRACKET 41
#define T_REMAINDER 42
#define T_BITWISE_AND 43
#define T_BITWISE_OR 44
#define T_BITWISE_NOT 45
#define T_LEFT_SHIFT 46
#define T_RIGHT_SHIFT 47
#define T_BREAK 48
#define T_CONTINUE 49
#define T_RETURN 50
#define T_SET 51
#define T_SEQUENCE 52
#define T_IS 53
#define T_NOT 54
#define T_ODD 55
#define T_TERNARY 56
#define T_SQRT 57
#define T_TRY 58
#define T_RNA_SEQ 59
#define T_DNA_SEQ 60
#define T_NA_SEQ 61
#define T_IN 62

%}

DIGIT           [0-9]
NON_ZERO_DIGIT  [1-9]
/*SIGN            [-+]*/
EXPONENT        [Ee][+-]?{DIGIT}+
FLOAT           ({NON_ZERO_DIGIT}{DIGIT}*|0)(\.{DIGIT}+)?{EXPONENT}?|[1-9]\d*(\.\d+)?{EXPONENT}?

%%

"//".* {}  
"#".* {}
[ \t]; 
[\n];
[0-9]*		{yylval.ival = atoi(yytext); return T_INT;}
{FLOAT} {yylval.fval = atoi(yytext); return T_FLOAT;}
[U]* {return T_RNA_SEQ;}
[T]* {return T_DNA_SEQ;}
[ACG]* {return T_NA_SEQ;}
[iI][nN][tT] {return K_INT;} /* */ 
[bB][oO][oO][lL] {return T_BOOL;}
[fF][lL][oO][aA][tT] {return T_FLOAT_K;}
[sS][tT][rR][iI][nN][gG]|[tT][eE][xX][tT] {return T_STRING_K;}
[eE][nN][uU][mM] {return T_ENUM;}
[sS][tT][rR][uU][cC][tT] {return T_STRUCT;}
[aA][rR][rR][aA][yY] {return T_ARRAY;}
[nN][uU][lL][lL] {return T_NULLP;}
[iI][fF]|[sS][iI] {return T_IF;}
[eE][lL][sS][eE] {return T_ELSE;}
[eE][lL][sS][eE]\s{0,2}[iI][fF]|[Ee][lL][iI][fF] {return T_ELSEIF;}
[fF][uU][nN][cC][tT][iI][oO][nN]|[fF][uU][nN][cC]|[dD]|[eE][fF] {return T_FUNC;}
[oO][uU][tT][pP][uU][tT] {return T_OUTPUT;}
[iI][nN][pP][uU][tT] {return T_INPUT;}
[cC][oO][nN][sS][tT] {return T_CONST;}
[iI][mM][pP][oO][rR][tT] {return T_IMPORT;}
[tT][rR][uU] {return T_TRUE;}
[fF][aA][lL][Ss][eE] {return T_FALSE;}
[wW][hH][iI][lL][eE] {return T_WHILE;}
[fF][oO][rR] {return T_FOR;}
[aA][nN][dD]|"&&" {return T_AND;}
[oO][rR]|"||" {return T_OR;}
[bB][rR][eE][aA][kK] { return T_BREAK; }
[cC][oO][nN][tT][iI][nN][uU][eE] { return T_CONTINUE; }
[rR][eE][tT][uU][rR][nN] { return T_RETURN; }
[sS][eE][tT] { return T_SET;}
[sS][eE][qQ][uU][eE][nN][cC][eE] { return T_SEQUENCE; }
[iI][sS] { return T_IS;}
[sS][qQ][rR][tT] | [Ss][qQ][uU][aA][rR][eE][rR][oO][oO][tT] { return T_SQRT;}
[oO][dD][dD] { return T_ODD;}
[tT][rR][yY] { return T_TRY;}
[iI][nN] { return T_IN;}

"=>" {return T_ARROW;}
"+"  {return T_PLUS;}
"-" | "−"  {return T_MINUS;}
"*" | "×" {return T_MULTIPLY;}
"/" | "÷"  {return T_DIVISION;}
"==" {return T_EQUALEQUAL;}
"!=" {return T_NOTEQUAL;}
"<" | "<" {return T_LESSTHAN;}
">"  {return T_MORETHAN;}
"<=" | "≤" {return T_LESSOREQUAL;}
">=" {return T_GREATEROREQUAL;}
";"  {return T_SEMICOLON;}
"="  {return T_EQUAL;}
","  {return T_COMMA;}
"}"  {return T_RBRACE;}
"{"  {return T_LBRACE;}
")"  {return T_RPAREN;}
"("  {return T_LPAREN;}
"]"  {return T_RBRACKET;}
"["  {return T_LBRACKET;}
"%"  { return T_REMAINDER; }
"&"  { return T_BITWISE_AND; }
"|"  { return T_BITWISE_OR; }
"~"  { return T_BITWISE_NOT; }
"<<" { return T_LEFT_SHIFT; }
">>" { return T_RIGHT_SHIFT; }
"?"  { return T_TERNARY; }
[nN][oO][tT] | "!" { return T_NOT;}
\/\*[^*]*\*+([^/*][^*]*\*+)*\/ {}

"using math" {
  #include "inc/math.h" 
  usingMath = 1;
  }

 /*([a-zA-Z_\x80-\xff\xc2-\xf4[^[:digit:][:punct:][:blank:]]]*)   this doesn't work for identifiers
[a-zA-Z_\u0000-\uFFFF\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02AF\u0370-\u037D\u037F-\u1FFF\u2000-\u206F\u2074-\u20CF\u2100-\u218F\u2460-\u24FF\u2500-\u2BEF\u2C00-\u2DFF\u2E80-\u2FFF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF\U00010000-\U000EFFFF\U00013000-\U0001342F\U00013000-\U0001342E\U0001303A-\U00013438\U0001F000-\U0001F02F\U0001F0A0-\U0001F0FF\U0001F100-\U0001F64F\uD83C-\uDFFF\U0001F900-\U0001F9FF\U0001F680-\U0001F6FF]+ */ 
[[:alpha:]_][[:alnum:]_]* { return T_IDENTIFIER; }

. { 
      char msg[100];
      sprintf(msg, "Unexpected token '%s' at line %d\n", yytext, lineno);
      yyerror(msg);
  }
  
%%