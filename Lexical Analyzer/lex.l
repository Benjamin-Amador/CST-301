%{
int chars = 0; /* Here we are declaring and initializing counters */
int words = 0; /* Here we are declaring and initializing counters */
int lines = 0; /* Here we are declaring and initializing counters */
int errors = 0; /* Here we are declaring and initializing counters */
%}

%%
\= {chars++; printf("%10s : EQUALS\n",yytext);} /* Here we are declaring that = is a legal token */
\{ {chars++; printf("%10s : LEFTCURLY\n",yytext);} /* Here we are declaring that { is a legal token */
\} {chars++; printf("%10s : RIGHTCURLY\n",yytext);} /* Here we are declaring that } is a legal token */
\; {chars++; printf("%10s : END_SYMBOL\n",yytext);} /* Here we are declaring that ; is a legal token */
\( {chars++; printf("%10s : LEFTPAREN\n",yytext);} /* Here we are declaring that ( is a legal token */
\) {chars++; printf("%10s : RIGHTPAREN\n",yytext);} /* Here we are declaring that ) is a legal token */
int[a-zA-Z]{1,50} {errors++; chars += strlen(yytext); printf("%10s : ERROR AT LINE %d, CHARACTER %d: DID USER MEAN TYPE INT?\n",yytext,lines+1,chars+1);}
return[a-zA-Z]{1,50} {errors++; chars += strlen(yytext); printf("%10s : ERROR AT LINE %d, CHARACTER %d: DID USER MEAN RETURN?\n",yytext,lines+1,chars+1);}
write[a-zA-Z]{1,50} {errors++; chars += strlen(yytext); printf("%10s : ERROR AT LINE %d, CHARACTER %d: DID USER MEAN WRITE?\n",yytext,lines+1,chars+1);}
[0-9][a-zA-Z.]+ {chars++; errors++; printf("%10s : ERROR AT LINE %d, CHARACTER %d: USER CANNOT ENTER A NUMBER BEFORE A VARIABLE NAME\n",yytext,lines+1,chars+1);}
int {chars += strlen(yytext); printf("%10s : Type\n",yytext);} /* Here we are saying that the token int is a type token */
return|write {chars += strlen(yytext); printf("%10s : Keyword\n",yytext);} /* Here we are saying that the tokens return and write are keywords */
[a-zA-Z]+ {words++; chars += strlen(yytext);printf("%10s : IDENTIFIER\n",yytext);} /* Here we are saying that a token made from a string of letters is an identifier */
[a-zA-Z][a-zA-Z0-9]+ {words++; chars += strlen(yytext);printf("%10s : IDENTIFIER\n",yytext);}
[0-9]+ {chars += strlen(yytext); printf("%10s : NUMBER\n",yytext);} /* A token created from a string of numbers is set as number */
\n {chars++; lines++;}
[ ]|[	] {chars++;} /* All spaces and tabs will increase the chars counter by 1 */
. {chars++; errors++; printf("%10s : ERROR AT LINE %d, CHARACTER %d: USER CANNOT ENTER AN ILLEGAL CHARACTER\n",yytext,lines+1,chars+1);}
;{2,100} {chars++; errors++; printf("%10s : ERROR AT LINE %d, CHARACTER %d: USER ADDED EXTRA SEMICOLON\n",yytext,lines+1,chars+1);}

%%

main(int argc, char **argv)
{
if(argc > 1){
          if(!(yyin = fopen(argv[1],"r"))){
             perror(argv[1]);
             return(1);
          }
        }
        yylex();
printf("Lines: %8d\nWords: %8d\nChars: %8d\nErrors: %7d\n", lines,words,chars,errors);

}