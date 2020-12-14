#include "tree.h"
static int nodeid=0;

//添加孩子节点
void TreeNode::addChild(TreeNode* child) {  
        if(this->child==NULL){
            this->child=child;
        }else{
            TreeNode* c=this->child;
            c->addSibling(child);
        }
}

//添加兄弟节点
void TreeNode::addSibling(TreeNode* sibling){
    TreeNode*s=this;
    while(s->sibling!=NULL){
        s=s->sibling;
    }
    s->sibling=sibling;
}

//构造函数
TreeNode::TreeNode(int lineno, int type) {
    this->lineno=lineno;
    this->nodeType=type;
}

//为AST节点递归编号
void TreeNode::genNodeId() {
    if(this!=NULL){
        this->nodeID=nodeid++;
        this->child->genNodeId();
        this->sibling->genNodeId();
    }
}

void TreeNode::printNodeInfo() {
    if(this!=NULL){
        //打印自身基本信息
        cout<<"lno@"<<this->lineno<<setw(8)<<"@"<<this->nodeID<<setw(16)<<nodeType2String(this->nodeType);
        //打印自身特殊信息
        this->printSpecialInfo();
        //打印孩子节点编号
        this->printChildrenId();
        cout<<endl;
    }
}

void TreeNode::printChildrenId() {
    if(this!=NULL){
        if(this->child!=NULL){
            cout<<setw(16)<<"children: [";
            TreeNode* c=this->child;
            while(c!=NULL){
                cout<<"@"<<c->nodeID<<" ";
                c=c->sibling;
            }
            cout<<"]";
        }    
    }
}

void TreeNode::printAST() {
    if(this!=NULL){
        this->printNodeInfo();
        this->child->printAST();
        this->sibling->printAST();
    }
}

void TreeNode::printSpecialInfo() {
    //根据节点类型打印特殊信息
    switch(this->nodeType){
        case NODE_CONST://如果是常量，打印类型和值
            switch (this->type->type){
                case VALUE_INT:
                cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->int_val;
                break;
                case VALUE_BOOL:
                cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->b_val;
                break;
                case VALUE_CHAR:
                cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->ch_val;
                break;
                case VALUE_STRING:
                cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->ch_val;
                break;
            }
        case NODE_VAR://如果是变量，打印变量名和变量类型
            cout<<setw(16)<<" var_name: "<<this->var_name;
            break;
        case NODE_EXPR://如果是表达式，打印运算类型
            cout<<setw(16)<<" operator: "<<opType2String(this->optype);
            break;
        case NODE_STMT://如果是语句，打印语句类型
            cout<<setw(16)<<" stmt: "<<sType2String(this->stype);
            break;
        case NODE_TYPE://如果是类型,打印类型
            cout<<setw(16)<<" type: "<<this->type->getTypeInfo();
            break;
        default:
            break;
    }
}

//节点类型转化为字符串
string TreeNode::nodeType2String (int type){
    switch(type){    
        case NODE_PROG:
            return "program";
        case NODE_STMT: 
            return "statement";
        case NODE_EXPR: 
            return "expression";  
        case NODE_CONST: 
            return "const";        
        case NODE_VAR: 
            return "variable";        
        case NODE_TYPE: 
            return "type";       
    }
    return "<>";
}

//语句类型枚举转化为字符串
string TreeNode::sType2String(int type) {
    switch(type){
        case STMT_SKIP: 
            return "skip";       
        case STMT_DECL: 
            return "declation";        
        case STMT_ASSIGN: 
            return "assign";        
        case STMT_RETURN: 
            return "return";       
        case STMT_IFELSE: 
            return "ifelse";       
        case STMT_WHILE: 
            return "while"; 
        case STMT_FOR: 
            return "for";    
        case STMT_CONTINUE: 
            return "continue";
        case STMT_BREAK: 
            return "break";
        case STMT_MAIN:
            return "main";
        case STMT_SCANF:
            return "scanf";
        case STMT_PRINTF:
            return "printf";
        case STMT_BLOCK:
            return "block";
    }
    return "?";
}

//运算符类型转化为字符串
string TreeNode::opType2String(int type){
    switch(type){      
        case OP_ADD: 
            return "+";        
        case OP_SUB: 
            return "-";       
        case OP_MUL: 
            return "*";       
        case OP_DIV: 
            return "/"; 
        case OP_MOD: 
            return "%";   
        case OP_INC: 
            return "++";       
        case OP_DEC: 
            return "--";       
        case OP_MINUS: 
            return "-"; 
        case OP_AND: 
            return "&&";
        case OP_OR: 
            return "||";     
        case OP_NOT: 
            return "!";   
        case OP_LT: 
            return "<";       
        case OP_GT: 
            return ">"; 
        case OP_LE: 
            return "<=";    
        case OP_GE: 
            return ">=";
        case OP_EQ: 
            return "==";
        case OP_NEQ: 
            return "!=";    
        case OP_ASSG: 
            return "=";
    }
    return "?";    
}

