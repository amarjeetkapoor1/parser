%{
    #include<iostream>
    #include<string.h>
    using namespace std;    
        void yyerror(char *);
    int yylex(void);
%}
%union {
    char *text;
    char ch;
    
};

%token<text> NUM
%token COMMENT
%token<text> SPACE
%token<text> WORD
%token<text> TOK_STRING 
%token<text> TOK_ID
%type<text> Words
%type<text> Spaces
%type<text> Description
%type<text> Line
%type<text> Assignment
%type<text> Assignments
%type<text> exp
%type<text> List
%type<text> List_element
%type<text> Parameter

%%

input:  
     Line
    | Line input {}
    ;

Line    :
         Assignments {$$=$1;} 
        | Description Line { cout<<$1<<"\n"<<$2;}    
        ;

Assignments:
             Assignment  {  $$=$1;}
            |Assignments Parameter {$$=strcat($1,$2);}
            ;
            
Assignment	: TOK_ID '=' exp ';' 
                {  
               
                    $$=strcat($1,"="); 
                }
            ;

exp		: NUM {$$=$1;}
		| '[' List ']' { $$=strcat("[",strcat($2,"]"));}
		;
		
Parameter:
             COMMENT  exp '\n'  { $$=strcat("//",strcat($2,"\n"));}
			;
List	:
		 List_element	{$$=$1;}
		| List_element ','	{$$=strcat($1,",");}
		| List List_element	{$$=strcat($1,$2);}
		;
List_element	: Spaces {}
                |Spaces NUM Spaces	{$$=$2;}
				| Spaces WORD Spaces	{$$=$2;}
				| Spaces NUM Spaces ':' Spaces WORD Spaces	{ $$=strcat($2,strcat(":",$6)); }
				| Spaces NUM Spaces ':' Spaces NUM Spaces	{ $$=strcat($2,strcat(":",$6));}
			;        
			

Description	: 
			 COMMENT Words '\n' {$$=$2; }
			;
			
Words : WORD {$$=$1;}
      | Spaces {$$=$1;}
      | Words Spaces { $$=strcat($1,$2);}
	  | Words WORD { $$=strcat($1,$2);}
	  ;
	  
Spaces 	:	 
		  SPACE	{ $$=$1; }
		  ;

		
%%

void yyerror(char *s) {
    cout<<"zv"<<endl;   
}

int main(void) {
    yyparse();
    return 0;
}
