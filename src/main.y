%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}


%token T_CHAR T_INT T_STRING T_BOOL 
%token SEMICOLON COMMA
%token IF ELSE WHILE FOR RETURN 
%token SCANF PRINTF
%token LBRACKET RBRACKET
%token IDENTIFIER INTEGER CHAR BOOL STRING
%right LOP_ASSIGN //=
%left AND OR
%right NOT
%left LT GT LE GE EQ NE //< > <= >= == !=
%left ADD SUB //+-
%left MUL DIV MOD //* /
%right PLUS MINUS  //+ -
%%

program: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| IDENTIFIER ASSIGN expr SEMICOLON{
    TreeNode*node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addchild($3);
    $$=node;
}
| IF LBRACKET logic_expr RBRACKET statement {
    $$=new TreeNode($32->lineno,NODE_STMT);
    $$->stype=STMT_IFELSE;
    $$->addChild($3);
    $$->addChild($5);
    $$->addChild($7);
}
| IF LBRACKET logic_expr RBRACKET statment ELSE statement{
    $$=new TreeNode($3-<lineno,NODE_STMT);
    $$->stype=STMT_IFELSE;
    $$->addChild($3);
    $$->addChild($5);
    $$->addChild($7);
}
| WHILE LBRACKET logic_expr RBRACKET statement{
    $$=new TreeNode($3->lineno,NODE_STMT);
    $$->stype=STMT_WHILE;
    $$->addChild($3);
    $$->addChild($5);
}
| BREAK SEMICOLON{
    $$=new TreeNode(lineno,NODE_STMT);
    $$->stype=STMT_BREAK;
}
| CONTINUE SEMICOLON{
    
}
;
}
| FOR 
| WHILE
| RETURN
;



declaration: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDENTIFIER {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

expr: calc_expr{$$=$1;}
| logic_expr{$$=$1;}
| assign_expr{$$=$1;}
| relate_expr{$$=$1;}
;

calc_expr: mdm_expr{$$=$1;}
| calc_expr ADD mdm_expr{
    TreeNode* node=new TreeNode($1->$lineno,NODE_EXPR)
    node->optype=OP_ADD;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($2);
    $$=node;
}
| calc_expr SUB mdm_expr{
    TreeNode* node=new TreeNode($1->$lineno,NODE_EXPR)
    node->optype=OP_SUB;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($2);
    $$=node;
}
;

mdm_expr: unary_expr{$$=$1;}
| mdm_expr MUL unary_expr{
    TreeNode* node=new TreeNode($1->lineno,NODE_TYPE=MODE_EXPR);
    node->optype=OP_MUL;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| mdm_expr DIV unary_expr{
    TreeNode* node=new TreeNode($1->lineno,NODE_TYPE=MODE_EXPR);
    node->optype=OP_DIV;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| mdm_expr MOD unary_expr{
    TreeNode* node=new TreeNode($1->lineno,NODE_TYPE=MODE_EXPR);
    node->optype=OP_DIV;
    node->type=TYPE_INT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;

unary_expr: min_expr{$$=$1;}
| PLUS min_expr{
    TreeNode*node=new TreeNode($2->lineon,MODE_EXPR);
    node->optype=op_OPT;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| MINUS min_expr{
    TreeNode*node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_NEG;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| NOT min_expr{
    TreeNode* node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_NOT;
    node->type=TYPE_BOOL;
    node->addChild($2);
    $$=node;
}
;
min_expr: IDENTIFIER {
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_NULL;
    node->type=TYPE_INT;
    node->addChild($1);
    $$=node;
}
| LBRACKET expr RBRACKET {$$=$2;}
| INC IDENTIFIER{
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_INC;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| IDENTIFIER INC{
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_INC;
    node->type=TYPE_INT;
    node->addChild($1);
    $$=node;
}
| DEC IDENTIFIER{
    TreeNode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_INC;
    node->type=TYPE_INT;
    node->addChild($2);
    $$=node;
}
| IDENTIFIER DEC{
    Treenode* node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_NULL;
    node->type=TYPE_INT;
    node->addChild($1);
    $$=node;
}
| INTEGER {
    TreeNode* node=TreeNode($1->lineno,NODE_EXPR);
    node->optype=op_NULL;
    node->type=TYPE_INT;
    node->addchild($1);
    $$=node;
}
| CHAR {
    TreeNode* node=TreeNode($1->lineno,NODE_EXPR);
    node->optype=op_NULL;
    node->type=TYPE_CHAR;
    node->addchild($1);
    $$=node;
}
| STRING {
    TreeNode* node=TreeNode($1->lineno,NODE_EXPR);
    node->optype=op_NULL;
    node->type=TYPE_STRING;
    node->addchild($1);
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