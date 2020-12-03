#include "tree.h"
static int nodeid=0;
void TreeNode::addChild(TreeNode* child) {  
        if(this->child==NULL){
            this->child=child;
        }else{
            TreeNode* c=this->child;
            c->addSibling(child);
        }
}

void TreeNode::addSibling(TreeNode* sibling){
    TreeNode*s=this;
    while(s->sibling!=NULL){
        s=s->sibling;
    }
    s->sibling=sibling;
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->lineno=lineno;
    this->nodeType=type;
}

void TreeNode::genNodeId() {
    if(this!=NULL){
        this->nodeID=nodeid++;
        this->child->genNodeId();
        this->sibling->genNodeId();
    }
}

void TreeNode::printNodeInfo() {
    if(this!=NULL){
        cout<<"lno@"<<this->lineno<<setw(8)<<"@"<<this->nodeID<<setw(16)<<nodeType2String(this->nodeType);
        this->printChildrenId();
        this->printSpecialInfo();
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

// You can output more info...

void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
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
            }
        case NODE_VAR:
            cout<<setw(16)<<" var_name: "<<this->var_name;
            break;
        case NODE_EXPR:
            cout<<setw(16)<<"operator:"<<opType2String(this->optype)<<setw(16)<<"type: "<<this->type->getTypeInfo();
            break;
        case NODE_STMT:
            cout<<setw(16)<<"stmt:"<<sType2String(this->stype);
            break;
        case NODE_TYPE:
            cout<<setw(16)<<"type:"<<this->type->getTypeInfo();
            break;
        default:
            break;
    }
}




// void TreeNode::printSpecialInfo() {
//     switch(this->nodeType){
//         case NODE_CONST:
//             switch (this->type->type)
//             {
//             case VALUE_INT:
//                 cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->int_val;
//                 break;
//             case VALUE_CHAR:
//                 cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->ch_val;
//                 break;
//             case VALUE_BOOL:
//                 cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->b_val;
//                 break;
//             case VALUE_STRING:
//                 cout<<setw(16)<<" type: "<<this->type->getTypeInfo()<<setw(16)<<" value: "<<this->str_val;
//                 break;
//             default:
//                 break;
//             }
//             break;
//         case NODE_VAR:
//             cout<<setw(16)<<" varname: "<<this->var_name<<setw(16)<<"type: "<<this->type->getTypeInfo();
//             break;
//         case NODE_EXPR:
//             cout<<setw(16)<<" operator: "<<opType2String(this->optype)<<setw(16)<<" type: "<<this->type->getTypeInfo();
//             break;
//         case NODE_STMT:
//             cout<<setw(16)<<" stmt: "<<sType2String(this->stype);
//             break;
//         case NODE_TYPE:
//             cout<<setw(16)<<" type: "<<this->type->getTypeInfo();
//             break;
//         default:
//             break;
//     }
// }
string TreeNode::sType2String(StmtType type) {
    switch(type){
        case STMT_SKIP: 
            return "skip";       
        case STMT_DECL: 
            return "decl";        
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
    }
    return "?";
}
string TreeNode::opType2String(OperatorType type){
    switch(type){      
        case OP_NOT: 
            return "!";        
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
        case OP_AND: 
            return "&&";
        case OP_OR: 
            return "||";       
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
        case OP_INC: 
            return "++";       
        case OP_DEC: 
            return "--";       
        case OP_MINUS: 
            return "-"; 
    }
    return "?";    
}
string TreeNode::nodeType2String (NodeType type){
    switch(type){    
        case NODE_CONST: 
            return "const";        
        case NODE_VAR: 
            return "variable";        
        case NODE_EXPR: 
            return "expression";       
        case NODE_TYPE: 
            return "type";       
        case NODE_STMT: 
            return "statement"; 
        case NODE_PROG: 
            return "program";    
        case NODE_COMP: 
            return "compUnit";
    }
    return "<>";
}
