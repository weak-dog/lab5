#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

struct TreeNode {
public:
    //节点基本信息
    int nodeID;         // 节点编号
    int lineno;         // 节点行号
    int nodeType;  // 节点类型
    TreeNode* child = nullptr; 
    TreeNode* sibling = nullptr;

    int optype; //表达式类型
    int stype;      //语句类型

    Type* type;          //变量、常量、类型需要用到这个属性

    //标识符相关属性
    string var_name;//标识符的名字
    int int_val;    //int型标识符的值
    char ch_val;    //char型标识符的值
    bool b_val;     //bool型标识符的值
    string str_val; //string型标识符的值

    TreeNode(int lineno, int type);//构造函数
    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printAST();        //递归打印AST，输出自己信息+孩子id，之后递归打印孩子和兄弟。
    void printNodeInfo();   //打印节点信息
    void printChildrenId(); //打印孩子节点的序号
    void printSpecialInfo();//打印节点特殊信息

    void genNodeId();       //给节点编号

    static string nodeType2String (int type);
    static string opType2String (int type);
    static string sType2String (int type);
    
};

//节点类型
enum NodeType
{
    NODE_PROG,  //程序
    NODE_STMT,  //语句
    NODE_EXPR,  //表达式
    NODE_CONST, //常量
    NODE_VAR,   //变量
    NODE_TYPE,  //变量类
};

//表达式节点子类型
enum OperatorType
{
    OP_ADD,     // +
    OP_SUB,     // -
    OP_MUL,     // *
    OP_DIV,     // /
    OP_MOD,     // %
    OP_INC,     // ++
    OP_DEC,     // --
    OP_MINUS,   // -
    OP_AND,     // &&
    OP_OR,      // ||
    OP_NOT,     // ！
    OP_LT,      // <
    OP_GT,      // >
    OP_LE,      // <=
    OP_GE,      // >=
    OP_EQ,      // ==
    OP_NEQ,     // !=
    OP_ASSG,    // = 
};

//语句节点子类型
enum StmtType {
    STMT_SKIP,
    STMT_DECL,      //声明语句
    STMT_ASSIGN,    //赋值语句
    STMT_RETURN,    //返回语句
    STMT_IFELSE,    //条件语句
    STMT_WHILE,     //while循环
    STMT_FOR,       //for循环
    STMT_CONTINUE,  //continue
    STMT_BREAK,     //break
    STMT_MAIN,      //main函数语句
    STMT_SCANF,     //输入语句
    STMT_PRINTF,    //输出语句
    STMT_BLOCK,     //代码块  
};
#endif