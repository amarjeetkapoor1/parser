%{

     #include<iostream>
    using namespace std; 
      std::string stringcontents;
      enum yytokentype {
        NUM = 258,
        COMMENT = 259,
        SPACE = 260,
        WORD= 261,
        TOK_STRING = 262,
        TOK_ID = 263
     };    
        int yylval;  
%}


%x comment cond_string
D [0-9]
E [Ee][-+]?{D}+
H [0-9a-fA-F]

U       [\x80-\xbf]
U2      [\xc2-\xdf]
U3      [\xe0-\xef]
U4      [\xf0-\xf4]
UNICODE {U2}{U}|{U3}{U}{U}|{U4}{U}{U}{U}

%%

"//" { BEGIN(comment); return COMMENT;}
<comment>{
    [  \t]+  { return SPACE;}
    
    {D}+{E}? |
    {D}*\.{D}+{E}? |
    {D}+\.{D}*{E}? { return NUM;}
    
    ":" {;return yytext[0];}
    
    "," {; return yytext[0];}
    
    "[" {; return yytext[0];} 
    
    "]" {; return yytext[0];}
    
    \n  {
            BEGIN(INITIAL); 
            ; 
            return yytext[0]; 
         }

}
W

{D}+{E}?  |
{D}*\.{D}+{E}? |
{D}+\.{D}*{E}? {   return NUM;}

"$"?[a-zA-Z0-9_]+  {  return TOK_ID;  }
"=" { ; return yytext[0];}
"[" { ; return yytext[0];}
"]" { ; return yytext[0];}
";" { ; return yytext[0];}

\"			{ BEGIN(cond_string); stringcontents.clear(); stringcontents += '\"';}
<cond_string>{
\\n			{ stringcontents += '\n'; }
\\t			{ stringcontents += '\t'; }
\\r			{ stringcontents += '\r'; }
\\\\			{ stringcontents += '\\'; }
\\\"			{ stringcontents += '"'; }
[^\\\n\"]		{ stringcontents += yytext; }
\" 	{ BEGIN(INITIAL);stringcontents += '\"'; 
			return TOK_STRING; }
}

[\n\r\t ]

. { ; return yytext[0]; }
%%

int yywrap(void) {
return 1;
}


int main(int argc, char **argv)
{
    if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
   }
   int tok;
    while(tok = yylex()) {
        printf("%d \n", tok);

    }
}
