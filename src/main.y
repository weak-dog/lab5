%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}

%token T_CHAR T_INT T_BOOL ADDR
%token SEMICOLON COMMA //; ,
%token IF ELSE WHILE FOR RETURN CONTINUE BREAK
%token SCANF PRINTF MAIN
%token LP RP LB RB
%token IDENTIFIER INTEGER CHAR BOOL STRING
%token TRUE FALSE

%right ASSIGN ADDASSIGN SUBASSIGN MULASSIGN DIVASSIGN //=
%left AND OR
%left LT GT LE GE EQ NEQ //< > <= >= == !=
%left ADD SUB //+-
%left MUL DIV MOD //* /
%right NOT //!
%right INC DEC
%right MINUS  //-
%%

program: statements {root = new TreeNode(0, NODE_PROG); root->child[0]=$1;}

statements: 
  MAIN statements{$$=$1;$$->addSibling($2);}
| statements statement {$$=$1;$$->addSibling($2);}
| statement {$$=$1;}
;

statement:
  block {$$=$1;}
| decl_stmt {$$=$1;}
| assign_stmt {$$=$1;}
| if_stmt {$$=$1;}
| for_stmt {$$=$1;}
| while_stmt {$$=$1;}
| jump_stmt {$$=$1;}
| io_stmt {$$=$1;}
| semi_stmt {$$=NULL;}
| expr {$$=$1;}
;

semi_stmt: SEMICOLON ;

block: LB statements RB {$$=$2;};

decl_stmt:
  decl_stmt COMMA assign_stmt {
    $$=$1;
    $$->addSibling($3);
}
| decl_stmt COMMA IDENTIFIER {
    $$=$1;
    $$->addSibling($3);
}
| T IDENTIFIER {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->child[0]=$1;
    $$->child[1]=$2;
    $$->sType=STMT_DECL;
}
| T assign_stmt {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->child[0]=$1;
    $$->child[1]=$2;
    $$->sType=STMT_DECL;
}


assign_stmt:
  IDENTIFIER ASSIGN expr {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->sType=STMT_ASSIGN;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| IDENTIFIER ADDASSIGN expr {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->sType=STMT_ASSIGN;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| IDENTIFIER SUBASSIGN expr {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->sType=STMT_ASSIGN;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| IDENTIFIER MULASSIGN expr {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->sType=STMT_ASSIGN;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| IDENTIFIER DIVASSIGN expr {
    $$=new TreeNode($1->lineno,NODE_STMT);
    $$->sType=STMT_ASSIGN;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
;

if_stmt:
  IF LP expr RP statements ELSE statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_IFELSE;
    $$->child[0]=$3;
    $$->child[1]=$5;
    $$->child[2]=$7;
}
| IF LP expr RP statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_IFELSE;
    $$->child[0]=$3;
    $$->child[1]=$5;
}
;

for_stmt:
  FOR LP decl_stmt SEMICOLON expr SEMICOLON expr RP statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    $$->child[0]=$3;
    $$->child[1]=$5;
    $$->child[2]=$7;
    $$->child[3]=$9;
}
| FOR LP SEMICOLON expr SEMICOLON expr RP statements {//TODO for语句缺少怎么处理
    $$=new TreeNode($4->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node=new TreeNode($4->lineno,NODE_NULL);
    $$->child[0]=node;
    $$->child[1]=$4;
    $$->child[2]=$6;
    $$->child[3]=$8;
}
| FOR LP decl_stmt SEMICOLON SEMICOLON expr RP statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node=new TreeNode($3->lineno,NODE_NULL);
    $$->child[0]=$3;
    $$->child[1]=node;
    $$->child[2]=$6;
    $$->child[3]=$8;
}
| FOR LP decl_stmt SEMICOLON expr SEMICOLON RP statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node=new TreeNode($3->lineno,NODE_NULL);
    $$->child[0]=$3;
    $$->child[1]=$5;
    $$->child[2]=node;
    $$->child[3]=$8;
}
| FOR LP decl_stmt SEMICOLON SEMICOLON RP statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node1=new TreeNode($3->lineno,NODE_NULL);
    TreeNode* node2=new TreeNode($3->lineno,NODE_NULL);
    $$->child[0]=$3;
    $$->child[1]=node1;
    $$->child[2]=node2;
    $$->child[3]=$7;
}
| FOR LP SEMICOLON expr SEMICOLON RP statements {
    $$=new TreeNode($4->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node1=new TreeNode($4->lineno,NODE_NULL);
    TreeNode* node2=new TreeNode($4->lineno,NODE_NULL);
    $$->child[0]=node1;
    $$->child[1]=$4;
    $$->child[2]=node2;
    $$->child[3]=$7;
}
| FOR LP SEMICOLON SEMICOLON expr RP statements {
    $$=new TreeNode($5->lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node1=new TreeNode($5->lineno,NODE_NULL);
    TreeNode* node2=new TreeNode($5->lineno,NODE_NULL);
    $$->child[0]=node1;
    $$->child[1]=node2;
    $$->child[2]=$5;
    $$->child[3]=$7;
}
| FOR LP SEMICOLON SEMICOLON RP statements {
    $$=new TreeNode(lineno,NODE_STMT);
    $$->sType=STMT_FOR;
    TreeNode* node1=new TreeNode(lineno,NODE_NULL);
    TreeNode* node2=new TreeNode(lineno,NODE_NULL);
    TreeNode* node3=new TreeNode(lineno,NODE_NULL);
    $$->child[0]=node1;
    $$->child[1]=node2;
    $$->child[2]=node3;
    $$->child[3]=$6;
}
;

while_stmt:
  WHILE LP expr RP statements {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_WHILE;
    $$->child[0]=$3;
    $$->child[1]=$5;
}
;

jump_stmt:
  BREAK {$$=$1;}
| CONTINUE {$$=$1;}
| RETURN {$$=$1;}
| RETURN expr {$$=$1;$$->child[0]=$2;}
;

io_stmt: 
  PRINTF LP expr RP {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_PRINTF;
    $$->child[0]=$3;
}
| PRINTF LP STRING COMMA expr RP {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_PRINTF;
    $$->child[0]=$3;
    $$->child[1]=$5;
}
| PRINTF LP STRING COMMA ADDR expr RP {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_PRINTF;
    $$->child[0]=$3;
    $$->child[1]=$6;
}
| SCANF LP expr RP {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_SCANF;
    $$->child[0]=$3;
}
| SCANF LP STRING COMMA expr RP {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_SCANF;
    $$->child[0]=$3;
    $$->child[1]=$5;
}
| SCANF LP STRING COMMA ADDR expr RP {
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->sType=STMT_SCANF;
    $$->child[0]=$3;
    $$->child[1]=$6;
}
;

expr:
  LP expr RP {$$=$2;}
| expr ADD expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_ADD;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr SUB expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_SUB;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr MUL expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_MUL;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr DIV expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_DIV;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr MOD expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_MOD;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| SUB expr %prec MINUS {
    $$=new TreeNode($2->lineno,NODE_EXPR);
    $$->opType=OP_MINUS;
    $$->valType=VALUE_INT;
    $$->child[0]=$2;
}
| INC IDENTIFIER {//TODO change or not
    $$=new TreeNode($2->lineno,NODE_EXPR);
    $$->opType=OP_INC;
    $$->valType=VALUE_INT;
    $$->child[0]=$2;
}
| IDENTIFIER INC {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_INC;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
}
| DEC IDENTIFIER {
    $$=new TreeNode($2->lineno,NODE_EXPR);
    $$->opType=OP_DEC;
    $$->valType=VALUE_INT;
    $$->child[0]=$2;
}
| IDENTIFIER DEC {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_INC;
    $$->valType=VALUE_INT;
    $$->child[0]=$1;
}
| expr AND expr {
    $$=new TreeNode($3->lineno,NODE_EXPR);
    $$->opType=OP_AND;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr OR expr {
    $$=new TreeNode($3->lineno,NODE_EXPR);
    $$->opType=OP_OR;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| NOT expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_NOT;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$2;
}
| expr LT expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_LT;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr GT expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_GT;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr LE expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_LE;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr GE expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_GE;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr EQ expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_EQ;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| expr NEQ expr {
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->opType=OP_NEQ;
    $$->valType=VALUE_BOOL;
    $$->child[0]=$1;
    $$->child[1]=$3;
}
| TRUE  {$$=$1;}
| FALSE {$$=$1;}
| IDENTIFIER {$$=$1;}
| CHAR {$$=$1;}
| INTEGER {$$=$1;}
;

T: 
  T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->valType = VALUE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->valType = VALUE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->valType = VALUE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}


