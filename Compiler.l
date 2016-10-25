%{
#include "Parserbase.h"
%}

%option noyywrap
%option yylineno

decimal [0-9]+"."[0-9]+
num		[0-9]+
char	[.]
name	[A-Za-z][A-Za-z0-9_]*
comment	(["//"[.]*\\n]|["/*"[.|\n]*"*/"])
string	(\".*\")

%%
	/*	KEYWORDS */

"\t"		{/*Ignore Tabs*/}
"int"		{return ParserBase::INT;}
"float"		{return ParserBase::FLOAT;}
"double"	{return ParserBase::DOUBLE;}
"long"		{return ParserBase::LONG;}
"void"		{return ParserBase::VOID;}
"short"		{return ParserBase::SHORT;}

	/*	RESERVED WORDS	*/
"return"	{return ParserBase::RETURN;}
"printf"	{return ParserBase::PRINTF;}
"if"		{return ParserBase::IF;}
"while"		{return ParserBase::WHILE;}
"for"		{return ParserBase::FOR;}

	/*	ARITHMETIC OPERATORS */
"+"			{return ParserBase::ADDOP;}
"-"			{return ParserBase::MINUSOP;}
"/"			{return ParserBase::DIVOP;}
"*"			{return ParserBase::MULTOP;}

	/*	LHS ONLY OPERATORS	*/
"++"		{return ParserBase::PLUSPLUS;}
"--"		{return ParserBase::MINUSMINUS;}

	/*	COMPARISON OPERATORS */
"=="		{return ParserBase::COMPEQUALS;}
"<"			{return ParserBase::LESSTHAN;}
">"			{return ParserBase::MORETHAN;}

	/*	ASSIGN OPERATORS	*/
"="			{return ParserBase::EQUALS;}
"+="		{return ParserBase::PLUSEQUALS;}
"-="		{return ParserBase::MINUSEQUALS;}
	/*NB: Need to add other types of assign*/

	/*	SINGLE SYMBOLS	*/
","			{return ParserBase::COMMA;}
"("			{return ParserBase::LRB;}
")"			{return ParserBase::RRB;}
"{"			{return ParserBase::LCB;}
"}"			{return ParserBase::RCB;}
"["			{return ParserBase::LSB;}
"]"			{return ParserBase::RSB;}
"'"			{return ParserBase::INVCOMMA;}
";"			{return ParserBase::SEMICOLON;}

	/*	...THINGS	*/
{decimal}	{return ParserBase::DECIMAL;}
{num}		{return ParserBase::NUM;}
{char}		{return ParserBase::CHAR;}
{name}		{return ParserBase::NAME;}
{comment}	{/*We return nothing for comment*/}
{string}	{return ParserBase::STRING;}

" "			{/*Ignore whitespace*/}
"\n"		{/*Ignore newlines*/}
.			{/*Ignore bad characters*/}
