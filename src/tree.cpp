#include "tree.h"
static int nodeid=0;

//构造函数
TreeNode::TreeNode(int lineno, int type) {
    this->lineno=lineno;
    this->nodeType=type;
    for(int i=0;i<MAX_CHILD;i++)
        this->child[i]=nullptr;
    this->sibling=nullptr;
}
//添加兄弟结点
void TreeNode::addSibling(TreeNode* sibling){
    TreeNode*s=this;
    while(s->sibling!=NULL){
        s=s->sibling;
    }
    s->sibling=sibling;
}
//递归给结点编号
void TreeNode::genNodeId() {
    if(this!=nullptr){
        this->nodeID=nodeid++;
        int i=0;
        while(i<4&&this->child[i++]!=nullptr){
            this->child[i-1]->genNodeId();
        }
        this->sibling->genNodeId();
    }
}
//递归打印AST
void TreeNode::printAST() {
    if(this!=nullptr){
        this->printNodeInfo();
        int i=0;
        while(i<4&&this->child[i++]!=nullptr){
            this->child[i-1]->printAST();
        }
        this->sibling->printAST();
    }
}
//打印节点信息
void TreeNode::printNodeInfo() {
    if(this!=nullptr){
        //打印自身基本信息
        cout<<"lno@"<<this->lineno<<setw(8)<<"@"<<this->nodeID<<setw(16)<<nodeType2String(this->nodeType);
        //打印自身特殊信息
        this->printSpecialInfo();
        //打印孩子节点编号
        this->printChildrenId();
        cout<<endl;
    }
}
//打印孩子节点序号
void TreeNode::printChildrenId() {
    if(this!=nullptr){
        if(this->child[0]){
            cout<<setw(16)<<"children: [";
            int i=0;
            while(i<4&&this->child[i++]!=nullptr){
                cout<<"@"<<this->child[i-1]->nodeID<<" ";
            }
            cout<<"]";
        }    
    }
}
//打印节点特殊信息
void TreeNode::printSpecialInfo() {
    //根据节点类型打印特殊信息
    switch(this->nodeType){
        case NODE_CONST://如果是常量，打印类型和值
            switch (this->valType){
                case VALUE_INT:
                    cout<<setw(16)<<" type: "<<this->getTypeInfo(this->valType);//<<setw(16)<<" value: "<<this->int_val;
                break;
                case VALUE_BOOL:
                    cout<<setw(16)<<" type: "<<this->getTypeInfo(this->valType);//<<setw(16);<<" value: "<<this->b_val;
                break;
                case VALUE_CHAR:
                    cout<<setw(16)<<" type: "<<this->getTypeInfo(this->valType);//<<setw(16)<<" value: "<<this->ch_val;
                break;
                case VALUE_STRING:
                    cout<<setw(16)<<" type: "<<this->getTypeInfo(this->valType);//<<setw(16);<<" value: "<<this->ch_val;
                break;
            }
        break;
        case NODE_VAR://TODO如果是变量，打印变量名和变量类型
            cout<<setw(16)<<" var_name: "<<this->varName;
        break;
        case NODE_EXPR://如果是表达式，打印运算类型
            cout<<setw(16)<<" operator: "<<opType2String(this->opType);
        break;
        case NODE_STMT://如果是语句，打印语句类型
            cout<<setw(16)<<" stmt: "<<sType2String(this->sType);
        break;
        case NODE_TYPE://如果是类型,打印类型
            cout<<setw(16)<<" type: "<<this->getTypeInfo(valType);
        break;
        default:
            break;
    }
}
//结点类型转化为字符串
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

string TreeNode::getTypeInfo(int type) {
    switch(type) {
        case VALUE_BOOL:
            return "bool";
        case VALUE_INT:
            return "int";
        case VALUE_CHAR:
            return "char";
        case VALUE_STRING:
            return "string";
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "?";
}

//生成标签
// void tree::gen_label(){
//     TreeNode* p=root;
//     p->label.begin_label="_start";
//     recursive_get_label(p);
// }
//TODO生成汇编代码
// void tree::gen_code(ostream $out){
//     gen_header(out);
//     gen_decl(out,root);//TODO 通过符号表生成全局变量
//     //TreeNode* p=root->child;
//     //if(p->);
//     out<<"\t.text"<<endl;
//     out<<"\t.global _start"<<endl;
//     recursive_gen_code(out,root);
//     if(root->label,next!="")
//         out<<root->label.next_label<<":"<<endl;
//     out<<"\tret"<<endl;
// }
//类型检查
// void tree::type_check(TreeNode *t){
//     switch(t->nodeType){
//         case NODE_STMT:
//             switch(t->stype){
//                 case STMT_IF:
//                     if(t->child->valType!=BOOL)
//                     cerr<<"Bad boolean type at line: "<<t->lineno<<endl;    
//                     break;
//                 case STMT_WHILE:
//                     if(t->child->valType!=BOOL)
//                     cerr<<"Bad boolean type at line: "<<t->lineno<<endl;    
//                     break;
//                 case STMT_ASSIGN:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"Assign error type at line: "<<t->lineno<<endl;
//                     break;
//                 case STMT_FOR:
//                     if(t->child->sibling!=BOOL&&t->child->sibling->nodeType!=STMT_NULL)
//                         cerr<<"Bad boolean type at line: "<<t->lineno<<endl;    
//                     break;
//             }
//             break;
//         case NODE_EXPR:
//             switch(t->optype){
//                 case OP_ADD:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"Bad add type at line: "<<t->lineno<<<endl;
//                     break;
//                 case OP_SUB:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"Bad sub type at line: "<<t->lineno<<<endl;
//                     break;
//                 case OP_MUL:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"Bad mul type at line: "<<t->lineno<<<endl;
//                     break;
//                 case OP_DIV:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"Bad div type at line: "<<t->lineno<<<endl;
//                     break;
//                 case OP_MOD:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"Bad mod type at line: "<<t->lineno<<<endl;
//                     break;
//                 case OP_LE:
//                     if(t->child->valType!=t->child->sibling->valType||t->child->valType!=INT)
//                         cerr<<"Compare error at line: "<<t->lineno<<endl;
//                     break;
//                     break;
//                 case OP_GE:
//                     if(t->child->valType!=t->child->sibling->valType||t->child->valType!=INT)
//                         cerr<<"Compare error at line: "<<t->lineno<<endl;
//                     break;
//                 case OP_LT:
//                     if(t->child->valType!=t->child->sibling->valType||t->child->valType!=INT)
//                         cerr<<"Compare error at line: "<<t->lineno<<endl;
//                     break;
//                 case OP_GT:
//                     if(t->child->valType!=t->child->sibling->valType||t->child->valType!=INT)
//                         cerr<<"Compare error at line: "<<t->lineno<<endl;
//                     break;
//                 case OP_AND:
//                     if(t->child->valType!=t->child->sibling->valType||t->child->valType!=BOOL)
//                         cerr<<"AND error at line: "<<t->lineno<<endl;
//                     break;
//                 case OP_OR:
//                     if(t->child->valType!=t->child->sibling->valType||t->child->valType!=BOOL)
//                         cerr<<"OR error at line: "<<t->lineno<<endl;
//                     break;
//                 case OP_DEC:
//                     if(t->child->valType!=INT)
//                         cerr<<"DEC error at line: "<<t->lineno<<endl;
//                     break;
//                 case OP_INC:
//                     if(t->child->valType!=INT)
//                         cerr<<"INC error at lineno: "<<t->lineno<<endl;
//                     break;
//                 case OP_MINUS:
//                     if(t->child->valType!=INT)
//                         cerr<<"MINUS error at lineno: "<<t->lineno<<endl;
//                     break;
//                 case OP_EQ:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"EQ error at lineno: "<<t->lineno<<end;
//                     break;
//                 case OP_NEQ:
//                     if(t->child->valType!=t->child->sibling->valType)
//                         cerr<<"NEQ error at lineno: "<<t->lineno<<end;
//                     break;
//                 case OP_NOT:
//                     if(t->child->valType!=BOOL)
//                         cerr<<"NOT error at lineno: "<<t->lineno<<endl;
//                     break;
//             }
//             break;
//         break;
//     }
// }
//TODO 不知道是个啥
// void tree::get_temp_var(Node *t);
//新建一个标签
// string tree::new_label(void){
//     char tmp[20];
//     sprintf(tmp,"@%d",tree::label_seq);
//     tree::label_seq++;
//     return tmp;
// }
//递归获取标签
// void tree::recursive_get_label(Node *t){
//     if(t->nodeType==NODE_STMT)
//         stmt_get_label(t);
//     if(t->nodeType==NODE_EXPR)
//         expr_get_label(t);
// }
//语句生成标签
// void tree::stmt_get_label(Node *t){
//     switch (t->sType){
//         case STMT_WHILE:
//             {
//                 Node *last;
//                 Node *p;
//                 for (p = t->child[0]; p->kind == DECL_NODE; p = p->sibling) ;

//                 p->label.begin_label = t->label.begin_label;
//                 for (; p; p = p->sibling)
//                 {
//                     last = p;
//                     recursive_get_label(p);
//                 }
//                 t->label.next_label = last->label.next_label;
//                 if (t->sibling)
//                     t->sibling->label.begin_label = t->label.next_label;
//             }
//             break;

//         case STMT_WHILE:
//             {
//                 TreeNode* child1=t->child;//bool_expr
//                 TreeNode* child2=t->child->sibling;//statements
//                 if (t->label.begin_label == "")
//                     t->label.begin_label = new_label();
//                 child2->label.next_label = t->label.begin_label;
//                 child2->label.begin_label = child1->label.true_label = new_label();
//                 if (t->label.next_label == "")
//                     t->label.next_label = new_label();
//                 child1->label.false_label = t->label.next_label;
//                 if (t->sibling)
//                     t->sibling->label.begin_label = t->label.next_label;
//                 recursive_get_label(child1);
//                 recursive_get_label(child2);
//             }
//         case STMT_IFELSE://TODO fucK
//             {

//             }
//     /* ... */
// 	}
// }
//表达式生成标签
// void tree::expr_get_label(Node *t){
//     if(t->type!=BOOL)
//         return;
//     TreeNode* 
// }
//生成汇编语言头部
// void tree::gen_header(ostream &out){
//     out << "# my asm code header here" << endl;
// }
//全局变量生成代码 //TODO符号表还没弄
// void tree::gen_decl(ostream &out, Node *t){
//     out << endl << "# define variables and temp variables here" << endl;
// 	out << "\t.bss" << endl;
// 	for (; t->sType == STMT_DECL; t = t->sibling){
// 		for (TreeNode *p = t->children; p; p = p->sibling)
// 			if (p->valType == INT)//TODO
// 				out << "_" << symtbl.getname(p->attr.symtbl_seq) << ":" << endl;
//                 out << "\t.zero\t4" << endl;
//                 out << "\t.align\t4" << endl;
// 	}
// 	for (int i = 0; i < temp_var_seq; i++){
// 		out << "t" <<  i << ":" << endl;
//         out << "\t.zero\t4" << endl;
//         out << "\t.align\t4" << endl;
// 	}
// }
//递归生成汇编代码
// void tree::recursive_gen_code(ostream &out, Node *t){
//     if(t->nodeType==NODE_STMT)
//         stmt_gen_code(out,t);
//     else if(t->nodeType==NODE_EXPR)
//         expr_gen_code(out,t);
// }
//语句生成汇编代码
// void tree::stmt_gen_code(ostream &out, Node *t){
//     if(t->sType==STMT_BLOCK){
//         TreeNode* tmp=t->child;
//         while(tmp->sibling){
//             recursive_gen_code(out,tmp);
//             for()
//         }
//         for(int i=0;i->child;i++)
//     }
// }
//表达式生成汇编代码
// void tree::expr_gen_code(ostream &out, Node *t){

// }