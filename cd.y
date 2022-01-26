%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    void yyerror();
    int yylex();
    int yyparse();
    void push();
    char* top();
    void display();
    void create_poststr(char* a);
    void create_instr(char* a);
    void create_prestr(char* a);
    enum treetype {operator_node, number_node,variable_node};
    typedef struct tree {
        enum treetype nodetype;
        union {
            struct {struct tree *left, *right; char operator;} an_operator;
            struct {struct tree *center; char a_variable;} non_term;
            int a_number;
        } body;
    } tree;
    static tree *make_operator (tree *l, char o, tree *r) {
        tree *result= (tree*) malloc (sizeof(tree));
        result->nodetype= operator_node;
        result->body.an_operator.left= l;
        result->body.an_operator.operator= o;
        result->body.an_operator.right= r;
        return result;
    }
    static tree *make_number (int n) {
        tree *result= (tree*) malloc (sizeof(tree));
        result->nodetype= number_node;
        result->body.a_number= n;
        return result;
    }
    static tree *make_variable (tree *c,char v) {
        tree *result= (tree*) malloc (sizeof(tree));
        result->nodetype= variable_node;
        result->body.non_term.a_variable= v;
        result->body.non_term.center= c;
        return result;
    }
    static void printtree (tree *t, int level)
    {
        #define step 4
        if (t)
            switch (t->nodetype)
            {
                 case operator_node:
                    printtree (t->body.an_operator.right, level+step);
                    printf ("%*c%c\n\n\n", level+step, ' ', t->body.an_operator.operator);
                    printtree (t->body.an_operator.left, level+step);
                    break;
                 case variable_node:
                    printf ("%*c%c\n", level, ' ', t->body.non_term.a_variable);
                    printtree (t->body.non_term.center, level+step);
                    break; 
                 case number_node:
                    printf ("%*c%d\n", level, ' ', t->body.a_number);
                    break;
            }
    }
    static void printtree2 (tree *t, int level)
    {
        #define step 4
        if (t)
            switch (t->nodetype)
            {
               case operator_node:
                printtree2 (t->body.an_operator.right, level+step);
                printtree2 (t->body.an_operator.left, level+step);
                printf ("%*c%c\n\n\n", level+step, ' ', t->body.an_operator.operator);
                break;
               case variable_node:
                printf ("%*c%c\n", level, ' ', t->body.non_term.a_variable);
                printtree2 (t->body.non_term.center, level+step);
                break; 
               case number_node:
                printf ("%*c%d\n", level, ' ', t->body.a_number);
                break;
            }
    }
    static void printtree3 (tree *t, int level)
    {
        #define step 4
        if (t)
            switch (t->nodetype)
            {
               case operator_node:
                printf ("%*c%c\n\n\n", level+step, ' ', t->body.an_operator.operator);
                printtree3 (t->body.an_operator.right, level+step);
                printtree3 (t->body.an_operator.left, level+step);
                break;
               case variable_node:
                printf ("%*c%c\n", level, ' ', t->body.non_term.a_variable);
                printtree3 (t->body.non_term.center, level+step);
                break; 
               case number_node:
                printf ("%*c%d\n", level, ' ', t->body.a_number);
                break;
            }
    }
%}

%union{
    int a_number;
    struct tree *a_tree;
};
%token NEWLINE  IN_TO_PRE IN_TO_POST PRE_TO_POST PRE_TO_IN POST_TO_IN POST_TO_PRE
%left '+' '-'
%left '*' '/'
%token <a_number> ID
%type <a_tree> S X Y Z G A B C H I F J P K E L T

%%

S    : IN_TO_PRE NEWLINE {printf("\nEnter INFIX expression: ");}
       H { }

     | IN_TO_POST NEWLINE {printf("\nEnter INFIX expression: ");}
       G { }

     | PRE_TO_POST NEWLINE {printf("\nEnter PREFIX expression: ");} 
       I { }

     | PRE_TO_IN NEWLINE {printf("\nEnter PREFIX expression: ");} 
       J { }

     | POST_TO_IN NEWLINE {printf("\nEnter POSTFIX expression: ");}
       K { }

     | POST_TO_PRE NEWLINE {printf("\nEnter POSTFIX expression: ");} 
       L { }
     ;

H    : A NEWLINE{
                    printf("\n\nResulting PREFIX Expression: %s \n\n",top());
                    printf("PARSE TREE FOR INFIX EXPRESSION\n\n");
                    printtree ($$,1);
                    printf("\n\nThe entered string is successfully parsed.\n\n");
                    exit(1);
                }
G    : X NEWLINE{
                    printf("\nCompleted\n");
                    printf("\nPARSE TREE FOR INFIX EXPRESSION\n\n");
                    printtree ($$,1);
                    printf("\n\nThe entered string is successfully parsed.\n\n");
                    exit(1);
                }
I    : F NEWLINE{
                    printf("\n\nResulting POSTFIX Expression: %s \n\n",top());
                    printf("PARSE TREE FOR PREFIX EXPRESSION\n\n");
                    printtree2 ($$,1);
                    printf("\n\nThe entered string is successfully parsed.\n\n");
			        exit(1);
		        }
J    : P NEWLINE{
                    printf("\n\nResulting INFIX Expression: %s \n\n",top());
                    printf("PARSE TREE FOR PREFIX EXPRESSION\n\n");
                    printtree2 ($$,1);
                    printf("\n\nThe entered string is successfully parsed.\n\n");
                    exit(1);
                }
K    : E NEWLINE{
                    printf("\n\nResulting INFIX Expression: %s \n\n",top());
                    printf("PARSE TREE FOR POSTFIX EXPRESSION\n\n");
                    printtree3 ($$,1);
                    printf("\n\nThe entered string is successfully parsed.\n\n");
			        exit(1);
		        }
L    : T NEWLINE{
                    printf("\n\nResulting PREFIX Expression: %s \n\n",top());
                    printf("PARSE TREE FOR POSTFIX EXPRESSION\n\n");
                    printtree3 ($$,1);
                    printf("\n\nThe entered string is successfully parsed.\n\n");
			        exit(1);
		        }
     ;

A    :  A'+'B { create_prestr("+ "); $$ = make_operator(make_variable($1,'A'),'+',make_variable($3,'B')); }
     |  A'-'B { create_prestr("- "); $$ = make_operator(make_variable($1,'A'),'-',make_variable($3,'B')); }
     |  B { $$ = make_variable($1,'B'); }
     ;
B    :  B'*'C { create_prestr("* "); $$ = make_operator(make_variable($1,'A'),'*',make_variable($3,'B')); }
     |  B'/'C { create_prestr("/ "); $$ = make_operator(make_variable($1,'A'),'/',make_variable($3,'B')); }
     |  C { $$ = make_variable($1,'C'); }
     ;
C    :  ID { push();  $$ = make_number ($1); }
     | '(' A ')' { $$ = make_variable($2,'A'); }
     ;
X    : X '+' Y { printf("+ ");
                 $$ = make_operator(make_variable($1,'X'),'+',make_variable($3,'Y')); }
     | X '-' Y { printf("- ");
                 $$ = make_operator(make_variable($1,'X'),'-',make_variable($3,'Y')); }
     | Y { $$ = make_variable($1,'Y'); }
     ;
Y    : Y '*' Z { printf("* ");
                 $$ = make_operator(make_variable($1,'Y'),'*',make_variable($3,'Z')); }
     | Y '/' Z { printf("/ ");
                 $$ = make_operator(make_variable($1,'Y'),'/',make_variable($3,'Z')); }
     | Z { $$ = make_variable($1,'Z'); }
     ;
Z    : ID { printf("%d ",$1);
            $$ = make_number ($1); }
     | '(' X ')' { $$ = make_variable($2,'X'); }
     ;
F    :'+' F F { create_poststr(" +"); $$ = make_operator(make_variable($2,'F'),'+',make_variable($3,'F')); }
     |'*' F F { create_poststr(" *"); $$ = make_operator(make_variable($2,'F'),'*',make_variable($3,'F')); }
     |'-' F F { create_poststr(" -"); $$ = make_operator(make_variable($2,'F'),'-',make_variable($3,'F')); }
     |'/' F F { create_poststr(" /"); $$ = make_operator(make_variable($2,'F'),'/',make_variable($3,'F')); }
     | ID { push();  $$ = make_number ($1); }
     ;
P    :'+' P P { create_instr(" + ");$$ = make_operator(make_variable($2,'P'),'+',make_variable($3,'P')); }
     |'*' P P { create_instr(" * ");$$ = make_operator(make_variable($2,'P'),'*',make_variable($3,'P')); }
     |'-' P P { create_instr(" - ");$$ = make_operator(make_variable($2,'P'),'-',make_variable($3,'P')); }
     |'/' P P { create_instr(" / ");$$ = make_operator(make_variable($2,'P'),'/',make_variable($3,'P')); }
     | ID { push();  $$ = make_number ($1);}
     ;
E    : E E '+' { create_instr(" + "); $$ = make_operator(make_variable($1,'E'),'+',make_variable($2,'E')); }
     | E E '*' { create_instr(" * "); $$ = make_operator(make_variable($1,'E'),'*',make_variable($2,'E')); }
     | E E '-' { create_instr(" - "); $$ = make_operator(make_variable($1,'E'),'-',make_variable($2,'E')); }
     | E E '/' { create_instr(" / "); $$ = make_operator(make_variable($1,'E'),'/',make_variable($2,'E')); }
     | ID { push(); $$ = make_number ($1); }
     ;
T    : T T '+' { create_prestr("+ ");$$ = make_operator(make_variable($1,'T'),'+',make_variable($2,'T')); }
     | T T '*' { create_prestr("* ");$$ = make_operator(make_variable($1,'T'),'*',make_variable($2,'T')); }
     | T T '-' { create_prestr("- ");$$ = make_operator(make_variable($1,'T'),'-',make_variable($2,'T')); }
     | T T '/' { create_prestr("/ ");$$ = make_operator(make_variable($1,'T'),'/',make_variable($2,'T')); }
     | ID { push();$$ = make_number ($1); }
     ;
%%

#include"lex.yy.c"
char st[100][50];
int indx=0;

void push()
{
    strcpy(st[indx],yytext);
    display();
    indx++;
}

char* pop()
{
    return st[--indx];
}

char* top()
{
    return st[indx-1];
}

void display()
{
    int i;
    printf("\nStack: \n");
    for(i=indx;i>=0;--i)
       printf("\t%s\n",st[i]);
}

void create_poststr(char* a)
{
    char arr[20]={0};
    char* c1=pop();
    char* c2=pop();
    printf("\n%s and %s popped out of stack",c2,c1);
    strcat(arr,c2);
    strcat(arr," ");
    strcat(arr,c1);
    strcat(arr,a);
    printf("\nNew string created: %s and pushed into the stack.\n",arr);
    strcpy(st[indx],arr);
    display();
    indx++;
}

void create_instr(char* a)
{
    char arr[20]={0};
    char* c1=pop();
    char* c2=pop();
    printf("\n%s and %s popped out of stack",c2,c1);
    strcat(arr,"(");
    strcat(arr,c2);
    strcat(arr,a);
    strcat(arr,c1);
    strcat(arr,")");
    printf("\nNew string created: %s and pushed into the stack.\n",arr);
    strcpy(st[indx],arr);
    display();
    indx++;
}

void create_prestr(char* a)
{
    char arr[20]={0};
    char* c1=pop();
    char* c2=pop();
    printf("\n%s and %s popped out of stack",c2,c1);
    strcat(arr,a);
    strcat(arr,c2);
    strcat(arr," ");
    strcat(arr,c1);
    printf("\nNew string created: %s and pushed into the stack.\n",arr);
    strcpy(st[indx],arr);
    display();
    indx++;
}

void yyerror()
{
    printf("\nYou have entered INVALID Input!!\n");
    exit(0);
}

int main()
{
    printf("\n\t\tCONVERSION OF EXPRESSIONS\n");
    printf("\n  The project deals with conversions of different expressions -\n  infix, prefix and postfix. It consists of 6 interconversions \n  between these expressions which are implemented using stack \n  and its different functions. Also, stack is displayed at \n  each step to show its proper working. In addition to it, to \n  check if the input string is correct, it is parsed and the \n  Parse tree for the same is generated and printed as output\n\n");
    printf("\t   -----------------------------------\n");
    printf("\t    Enter 'a' for Infix to Prefix\n\t    Enter 'b' for Infix to Postfix\n\t    Enter 'c' for Prefix to Postfix\n\t    Enter 'd' for Prefix to Infix\n\t    Enter 'e' for Postfix to Infix\n\t    Enter 'f' for Postfix to Prefix\n");
    printf("\t   -----------------------------------\n");
    printf("\nEnter your Choice: ");
    yyparse();
    return 0;
}
