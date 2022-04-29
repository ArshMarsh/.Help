%{
#include <stdio.h>
#include <stdlib.h>
%}

%token UNION_SYMBOL
%token INTERSECTION_SYMBOL
%token DIFFERENCE_SYMBOL
%token SET_COMPLEMENT
%token INTEGER
%token DOUBLE
%token STRING
%token BOOL
%token STRING_IDENTIFIER
%token BOOL_IDENTIFIER
%token INT_IDENTIFIER
%token SET_SYMBOL
%token DOUBLE_IDENTIFIER
%token RETURN
%token NEWLINE
%token END_SYMBOL
%token DOT
%token COMMA
%token PLUS_SYMBOL
%token MINUS_SYMBOL
%token AND
%token OR
%token NOT
%token ASSIGN_OP
%token LP
%token RP
%token LCB
%token RCB
%token LT
%token LTE
%token GT
%token GTE
%token NOT_EQUAL
%token EQUALITY_SYMBOL
%token SET_IN_SYMBOL
%token SET_OUT_SYMBOL
%token SUBSET_SYMBOL
%token SUPERSET_SYMBOL
%token REMOVE_SYMBOL
%token IF
%token ELIF
%token ELSE
%token WHILE
%token FOR
%token DO
%token SET_CARDINALITY
%token START
%token END
%token SET
%token FUNCTION
%token PRINT
%token SET_DELETE
%token VARIABLE_IDENTIFIER
%token SINGLE_LINE_COM
%token MULTI_LINE_COM
%token CONNECTOR
%token HASHTAG
%token SPACE
%token CHANGE_SYMBOL
%token CONSOLE
%token CHANGE_TO_SYMBOL
%token LIST_SYMBOL
%token LBR
%token RBR
%start program
%%
program: 
	START stmts END

stmts:
	stmt
	| stmts stmt
	

//changed
stmt:
	assignment_stmt
	| set_stmt
	| if_stmt
	| print_stmt
	| loop_stmt
	| comment_stmt
	| function_stmts

assignment_stmt:
	VARIABLE_IDENTIFIER ASSIGN_OP variables END_SYMBOL
	| VARIABLE_IDENTIFIER ASSIGN_OP type END_SYMBOL
	| VARIABLE_IDENTIFIER ASSIGN_OP expr END_SYMBOL

expr:
	logical_expr
	| arithmetic_expr
	

logical_expr:
	set_logical 
	| variable_logical 
	| logical_expr logical_symbol set_logical
	| logical_expr logical_symbol variable_logical
	

variables : VARIABLE_IDENTIFIER | function_call

set_logical:
	set_operand bool_logical_symbol set_operand
	| set_operand bool_logical_symbol list
	| list bool_logical_symbol set_operand
	| list bool_logical_symbol list


variable_logical:
	variables bool_logical_symbol variables
	| variables bool_logical_symbol type
	| type bool_logical_symbol variables
	| type bool_logical_symbol type


bool_logical_symbol : LTE | GTE | GT | LT | NOT_EQUAL | EQUALITY_SYMBOL


logical_symbol : AND | OR

arithmetic_expr:
	 numbers arithmetic_symbol numbers
	| numbers arithmetic_symbol variables
	| variables arithmetic_symbol numbers
	| variables arithmetic_symbol variables
	| arithmetic_expr arithmetic_symbol numbers	
	| arithmetic_expr arithmetic_symbol variables	
	

arithmetic_symbol : PLUS_SYMBOL | MINUS_SYMBOL

type: numbers | STRING | BOOL 

numbers : INTEGER | DOUBLE | primitive_functions
;

print_stmt:
	PRINT LP type RP END_SYMBOL
	| PRINT LP expr RP END_SYMBOL
	| PRINT LP variables RP END_SYMBOL
	| PRINT LP set_operand RP END_SYMBOL
	| PRINT LP list RP END_SYMBOL

//changed
loop_stmt:
	while
	| for
	| do_while

while:
	WHILE LP logical_expr RP LCB stmts RCB
	| WHILE LP logical_expr RP LCB RCB

for:
	for_stmt LCB stmts RCB
	| for_stmt LCB RCB

for_stmt:
	FOR LP assignment_stmt logical_expr END_SYMBOL assignment_stmt RP

do_while:
	DO LCB stmts RCB WHILE LP logical_expr RP 
	| DO LCB RCB WHILE LP logical_expr RP 



function_stmts : function_def | function_call_stmt 

function_call_stmt : function_call END_SYMBOL

function_call: VARIABLE_IDENTIFIER LBR function_call_parameter RBR | VARIABLE_IDENTIFIER LBR RBR

function_call_parameter : variables
	| set_operand 
	| type
	| function_call_parameter COMMA variables
	| function_call_parameter COMMA set_operand
	| function_call_parameter COMMA type

function_def: function_sig LP parameters RP LCB stmts return_stmt RCB 
	| function_sig LP RP LCB stmts return_stmt RCB
	| function_sig LP parameters RP LCB return_stmt RCB
	| function_sig LP parameters RP LCB stmts RCB
	| function_sig LP parameters RP LCB RCB
	| function_sig LP RP LCB return_stmt RCB
	| function_sig LP RP LCB stmts RCB
	| function_sig LP RP LCB RCB

function_sig : FUNCTION VARIABLE_IDENTIFIER| SET_SYMBOL FUNCTION VARIABLE_IDENTIFIER

parameters: type_identifier VARIABLE_IDENTIFIER
	| parameters COMMA type_identifier VARIABLE_IDENTIFIER
	| SET 
	| parameters COMMA SET

type_identifier : DOUBLE_IDENTIFIER | INT_IDENTIFIER | STRING_IDENTIFIER | BOOL_IDENTIFIER

return_stmt:
	RETURN type END_SYMBOL 
	| RETURN variables END_SYMBOL
	| RETURN set_operand END_SYMBOL
	| RETURN set_ops END_SYMBOL
	| RETURN expr END_SYMBOL

primitive_functions:
	SET_CARDINALITY

//changed
comment_stmt:
	SINGLE_LINE_COM
	| MULTI_LINE_COM


if_stmt : normal_if | if_else | if_elif 

normal_if : IF LP logical_expr RP LCB stmts RCB 

if_else : IF LP logical_expr RP LCB stmts RCB ELSE LCB stmts RCB | IF LP logical_expr RP LCB RCB ELSE LCB stmts RCB

if_elif : IF LP logical_expr RP LCB stmts RCB elif_stmt ELSE LCB stmts RCB 
| IF LP logical_expr RP LCB RCB elif_stmt ELSE LCB stmts RCB

elif_stmt :  ELIF LP logical_expr RP LCB RCB
| ELIF LP logical_expr RP LCB stmts RCB 
| elif_stmt ELIF LP logical_expr RP LCB stmts RCB
| elif_stmt ELIF LP logical_expr RP LCB RCB


function_set : SET LBR RBR | SET LBR function_call_parameter RBR

set_operand : SET | SET_COMPLEMENT | function_set

set_stmt : set_assign | set_delete | set_add | set_remove | set_change | input_set_stmt | output_set_stmt {return 0;}
; 

set_assign : set_operand ASSIGN_OP list END_SYMBOL
| set_operand ASSIGN_OP set_operand END_SYMBOL
| set_operand ASSIGN_OP set_ops END_SYMBOL
;

set_delete : set_operand SET_DELETE LP RP END_SYMBOL
;

set_remove :  set_operand REMOVE_SYMBOL type END_SYMBOL
| set_operand REMOVE_SYMBOL variables END_SYMBOL
| set_operand REMOVE_SYMBOL list END_SYMBOL
| set_operand REMOVE_SYMBOL set_ops END_SYMBOL
;

set_add : set_operand PLUS_SYMBOL type END_SYMBOL
| set_operand PLUS_SYMBOL variables END_SYMBOL
| set_operand PLUS_SYMBOL list END_SYMBOL
| set_operand PLUS_SYMBOL set_ops END_SYMBOL
;

set_change : set_operand CHANGE_SYMBOL INTEGER CHANGE_TO_SYMBOL variables END_SYMBOL
| set_operand CHANGE_SYMBOL INTEGER CHANGE_TO_SYMBOL type END_SYMBOL
| set_operand CHANGE_SYMBOL variables CHANGE_TO_SYMBOL variables END_SYMBOL
| set_operand CHANGE_SYMBOL variables CHANGE_TO_SYMBOL type END_SYMBOL
;
  
list : type LIST_SYMBOL type 
	|  type LIST_SYMBOL variables 
	|  variables LIST_SYMBOL type 
	|  variables LIST_SYMBOL variables 		
	|  list LIST_SYMBOL type
	|  list LIST_SYMBOL variables
;

set_ops : set_operand set_op_symbols set_operand 
| set_operand set_op_symbols list
| list set_op_symbols set_operand
| list set_op_symbols list
| set_operand set_op_symbols set_ops
| list set_op_symbols set_ops
;

input_set_stmt : set_operand SET_IN_SYMBOL CONSOLE END_SYMBOL | set_operand SET_IN_SYMBOL STRING END_SYMBOL
;

output_set_stmt :  set_operand SET_OUT_SYMBOL CONSOLE END_SYMBOL | set_operand SET_OUT_SYMBOL STRING END_SYMBOL
;

set_op_symbols : UNION_SYMBOL | INTERSECTION_SYMBOL | DIFFERENCE_SYMBOL 
;


%%

int lineno = 1;

main() {
#ifdef YYDEBUG
  yydebug = 1;
  #endif
  return yyparse();
}
yyerror( char *s ) { fprintf(stderr,"%s on line: %d!\n",s, lineno); };