%{
     #include"parser.tab.h" 
     #include<iostream>
    using namespace std; 
      std::string stringcontents;
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
    [  \t]+  { yylval.text=yytext; return SPACE;}
    
    {D}+{E}? |
    {D}*\.{D}+{E}? |
    {D}+\.{D}*{E}? { yylval.text=yytext; return NUM;}
    
    ":" {yylval.ch=yytext[0];return yytext[0];}
    
    "," {yylval.ch=yytext[0]; return yytext[0];}
    
    "[" {yylval.ch=yytext[0]; return yytext[0];} 
    
    "]" {yylval.ch=yytext[0]; return yytext[0];}
    
    \n  {
            BEGIN(INITIAL); 
            yylval.ch=yytext[0]; 
            return yytext[0]; 
         }
    
    [^(/ \n \[ \] \, \: \t)]* {yylval.text=strdup(yytext); return WORD;}

}
W

{D}+{E}?  |
{D}*\.{D}+{E}? |
{D}+\.{D}*{E}? { yylval.text=yytext;  return NUM;}

"$"?[a-zA-Z0-9_]+  { yylval.text=yytext; return TOK_ID;  }
"=" { yylval.ch=yytext[0]; return yytext[0];}
"[" { yylval.ch=yytext[0]; return yytext[0];}
"]" { yylval.ch=yytext[0]; return yytext[0];}
";" { yylval.ch=yytext[0]; return yytext[0];}

\"			{ BEGIN(cond_string); stringcontents.clear(); stringcontents += '\"';}
<cond_string>{
\\n			{ stringcontents += '\n'; }
\\t			{ stringcontents += '\t'; }
\\r			{ stringcontents += '\r'; }
\\\\			{ stringcontents += '\\'; }
\\\"			{ stringcontents += '"'; }
[^\\\n\"]		{ stringcontents += yytext; }
\" 	{ BEGIN(INITIAL);stringcontents += '\"'; yylval.text=strdup(stringcontents.c_str());
			return TOK_STRING; }
}

[\n\r\t ]

. { yylval.ch=yytext[0]; return yytext[0]; }
%%

int yywrap(void) {
return 1;
}



