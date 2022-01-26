%{
	#include <stdio.h>
	#include "y.tab.h"
%}

DIGIT [0-9]
%%
["a"]			   {return IN_TO_PRE;}
["b"]			   {return IN_TO_POST;}
["c"]			   {return PRE_TO_POST;}
["d"]			   {return PRE_TO_IN;}
["e"]			   {return POST_TO_IN;}
["f"]              {return POST_TO_PRE;}
{DIGIT}+           {yylval.a_number = atoi(yytext); return ID;}
[\n]               return NEWLINE;
[-+*/]             {return yytext[0];}
.                  ;
%%

int yywrap()
{
	return 1;
}

