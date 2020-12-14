%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]
INTEGER [0-9]+
CHAR \'.?\'
STRING \".+\"
IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT} {string str=string(yytext);
        int index=0; 
    	while((index=str.find("\n",index)) < str.length()){
		    ++lineno;
		    index++;
	    }
    }

{LINECOMMENT} {++lineno;} 

"&"   return ADDR;
"int"   {TreeNode* node=new TreeNode(lineno,NODE_CONST);node->type=TYPE_INT; yylval=node;return T_INT;}
"bool"  {TreeNode* node=new TreeNode(lineno,NODE_CONST);node->type=TYPE_BOOL;yylval=node;return T_BOOL;}
"char"  {TreeNode* node=new TreeNode(lineno,NODE_CONST);node->type=TYPE_CHAR;yylval=node;return T_CHAR;}
"TRUE"  {TreeNode* node=new TreeNode(lineno,NODE_CONST);node->b_val=true; node->type->type=VALUE_BOOL;yylval=node;return TRUE;}
"FALSE" {TreeNode* node=new TreeNode(lineno,NODE_CONST);node->b_val=false;node->type->type=VALUE_BOOL;yylval=node;return FALSE;}
"+"   return ADD;
"-"   return SUB;
"*"   return MUL;
"/"   return DIV;
"%"   return MOD;
"++"  return INC;
"--"  return DEC;

"<"  return LT;
">"  return GT;
"<=" return LE;
">=" return GE; 
"==" return EQ;
"!=" return NEQ;
"&&" return AND;
"||" return OR;
"!"  return NOT;

"("  return LBRACKET;
")"  return RBRACKET;
"{"  return LBRACE;
"}"  return RBRACE;
"="  return ASSIGN;
"+=" return ADDASSIGN;
"-=" return SUBASSIGN;
"*=" return MULASSIGN;
"/=" return DIVASSIGN;
";"  return SEMICOLON;
","  return COMMA;

"return" return RETURN;
"continue" {TreeNode* node=new TreeNode(lineno,NODE_STMT);node->stype=STMT_CONTINUE;yylval=node;return CONTINUE;}
"break"    {TreeNode* node=new TreeNode(lineno,NODE_STMT);node->stype=STMT_BREAK;yylval=node;return BREAK;}
"for"    return FOR;
"while"  return WHILE;
"if"     return IF;
"else"   return ELSE;
"scanf"  return SCANF;
"printf" return PRINTF;

"void main()" {
    TreeNode* node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_MAIN;
    yylval=node;
    return MAIN;
}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1];
    yylval = node;
    return CHAR;
}

{STRING} {
    TreeNode* node=new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = string(yytext);
    yylval=node;
    return STRING;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;
. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%