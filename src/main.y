%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}

%token T_CHAR T_INT T_BOOL 
%token SEMICOLON COMMA //; ,
%token IF ELSE WHILE FOR RETURN CONTINUE BREAK
%token SCANF PRINTF MAIN
%token LBRACKET RBRACKET LBRACE RBRACE
%token IDENTIFIER INTEGER CHAR BOOL STRING
%token TRUE FALSE

%right ASSIGN //=
%left AND OR
%right NOT
%left LT GT LE GE EQ NEQ //< > <= >= == !=
%left ADD SUB //+-
%left MUL DIV MOD //* /
%right INC DEC
%right MINUS  //-
%%

program: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);}

statements:  statement {$$=$1;}
| MAIN statements{
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_MAIN;
    node->addChild($2);
    $$=node;
}
| LBRACE statements RBRACE {$$=$2;}
| statements statement {$$=$1;$$->addSibling($2);}
;

statement: SEMICOLON {$$ = new TreeNode($1->lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration {$$ = $1;}
| IF LBRACKET bool_expr RBRACKET statements ELSE statements {
    TreeNode* node=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_IFELSE;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    $$=node;
}
| IF LBRACKET bool_expr RBRACKET statements {
    TreeNode* node=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_IFELSE;
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
| WHILE LBRACKET bool_expr RBRACKET statements {
    TreeNode* node=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_WHILE;
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
| BREAK {$$=$1;}
| CONTINUE {$$=$1;}
| RETURN expr {
    TreeNode* node=new TreeNode($2->lineno,NODE_STMT);
    node->stype=STMT_RETURN;
    node->addChild($2);
    $$=node;
}
| FOR LBRACKET declaration SEMICOLON expr SEMICOLON expr RBRACKET statements {
    TreeNode* node=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$=node;
}
| IOFUNC {$$=$1;}
;

IOFUNC: PRINTF LBRACKET expr RBRACKET {
    TreeNode* node=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_PRINTF;
    node->addChild($3);
    $$=node;
}
| SCANF LBRACKET expr RBRACKET {
    TreeNode* node=new TreeNode($3->lineno,NODE_STMT);
    node->stype=STMT_SCANF;
    node->addChild($3);
    $$=node;
};

declaration: T IDENTIFIER {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$=node;
}
| T IDENTIFIER ASSIGN expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$=node;
}
| IDENTIFIER ASSIGN expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

expr: addsub_expr {$$=$1;}
| bool_expr {$$=$1;}
;

addsub_expr: mdm_expr {$$=$1;}
| addsub_expr ADD mdm_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_ADD;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| addsub_expr SUB mdm_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_SUB;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

mdm_expr
: unary_expr {$$=$1;}
| mdm_expr MUL unary_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_MUL;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| mdm_expr DIV unary_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_DIV;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| mdm_expr MOD unary_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_MOD;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

unary_expr: MINUS unary_expr {
    TreeNode* node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_MINUS;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| IDENTIFIER {$$=$1;}
| INTEGER {$$=$1;}
| CHAR {$$=$1;}
| LBRACKET expr RBRACKET {$$=$1;}
| INC IDENTIFIER {
    TreeNode* node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_INC;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| IDENTIFIER INC {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_INC;
    node->type=TYPE_INT;
    node->addChild($1);
    $$=node;
}
| DEC IDENTIFIER {
    TreeNode* node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_DEC;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| IDENTIFIER DEC {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_INC;
    node->type=TYPE_INT;
    node->addChild($1);
    $$=node;
}
;

bool_expr: TRUE {$$=$1;}
| FALSE {$$=$1;}
| NOT bool_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_NOT;
    node->type=TYPE_BOOL;
    node->addChild($2);
    $$=node;
}
| logic_expr {$$=$1;}
| bool_expr AND logic_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_AND;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| bool_expr OR logic_expr {
    TreeNode* node=new TreeNode($3->lineno,NODE_EXPR);
    node->optype=OP_OR;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

logic_expr: addsub_expr LT addsub_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_LT;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| addsub_expr GT addsub_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_GT;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| addsub_expr LE addsub_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_LE;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| addsub_expr GE addsub_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_GE;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| addsub_expr EQ addsub_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_EQ;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| addsub_expr NEQ addsub_expr {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_NEQ;
    node->type=TYPE_BOOL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}