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
    if(this==NULL)return;
    this->nodeID=nodeid++;
    this->child->genNodeId();
    this->sibling->genNodeId();
}

void TreeNode::printNodeInfo() {
    if(this==NULL)return;
    cout<<"lno@"<<this->lineno<<setw(8)<<"@"<<this->nodeID<<setw(16)<<nodeType2String(this->nodeType);
    this->printChildrenId();
    this->printSpecialInfo();
    cout<<endl;
}

void TreeNode::printChildrenId() {
    if(this==NULL)return;
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

void TreeNode::printAST() {
    if(this==NULL)return;
    this->printNodeInfo();
    this->child->printAST();
    this->sibling->printAST();
}

// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            break;
        case NODE_VAR:
            break;
        case NODE_EXPR:
            break;
        case NODE_STMT:
            break;
        case NODE_TYPE:
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
    return "<>";
}
