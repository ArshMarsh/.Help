%{
#include <stdio.h>
#include "y.tab.h"
%}

DIGIT   [0-9]
NUMBER 	[0-9]+
LETTER  [a-zA-Z]
WORD 	[a-zA-Z]+
SYMBOL	 \-|\_
SIGN	[+-]
ALPHANUMERIC 	{WORD}|{NUMBER}|\_

IDENTIFIER 	{LETTER}({LETTER}|{DIGIT}|{SYMBOL})* 
type		(string|char|bool|int|double|void)

%option yylineno
%%
-U-     return (UNION_SYMBOL);
-N-  	return INTERSECTION_SYMBOL;
-D-    	return DIFFERENCE_SYMBOL;
\~@{IDENTIFIER}   	return SET_COMPLEMENT;

{SIGN}?{NUMBER}	return INTEGER;
{SIGN}?{NUMBER}*\.{NUMBER}	return DOUBLE;
\"[^"]*\"	return STRING;
(True|False)	return BOOL;

string	return STRING_IDENTIFIER;
bool	return BOOL_IDENTIFIER;
int	return INT_IDENTIFIER;
@  	return SET_SYMBOL;
double	return DOUBLE_IDENTIFIER;

return	return RETURN;

\n { extern int lineno; lineno++;
    }
\;	return END_SYMBOL;
\.	return DOT;
\,	return COMMA;
\+	return PLUS_SYMBOL;
\-	return MINUS_SYMBOL;
\&\&	return AND;
\|\|	return OR;
\!	return NOT;
\=	return ASSIGN_OP;
\(	return LP;
\)	return RP;
\{	return LCB;
\}	return RCB;
\<	return LT;
(<=)	return LTE;
\>	return GT;
(>=)	return GTE;
\!\=	return NOT_EQUAL;
\=\=	return EQUALITY_SYMBOL;
\|	return CONNECTOR;

(<<<<)  return SET_IN_SYMBOL;
(>>>>)  return SET_OUT_SYMBOL;
(<==)	return SUBSET_SYMBOL;
(>==)	return SUPERSET_SYMBOL;
\~     	return REMOVE_SYMBOL;
\^      return(CHANGE_SYMBOL);
(-->)   return (CHANGE_TO_SYMBOL);

(_)   return (LIST_SYMBOL);

\[    return LBR;
\]    return RBR;

if	return IF;
elif	return ELIF;
else	return ELSE;

while	return WHILE;
for	return FOR;
do	return DO;
\|@{IDENTIFIER}\| 	return (SET_CARDINALITY);

start  	return START;
stop  	return END;
console return CONSOLE;



@({IDENTIFIER})	return SET;
function	return FUNCTION;
print       return PRINT;
delete    	return SET_DELETE;
({IDENTIFIER})	return VARIABLE_IDENTIFIER;


\#\#([^\#])*\#\#   return(MULTI_LINE_COM);
\#([^\n])*  return(SINGLE_LINE_COM);


[ \t\r]+ {};

.  printf(yytext[0]);


%%
int yywrap(void) {
    return 1;
}
