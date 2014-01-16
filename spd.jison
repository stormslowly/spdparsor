/** spd file parse jison
 *
 */



 %lex 

%%

\s+       /* skip white space */
SERVICES  /* skip the service  */
SYNC      /* skip the sync     */

"PROCEDURE"       return 'PROCEDURE';
","               return ',';
<<EOF>>           return 'EOF';
"("               return 'LBRACE';
")"               return 'RBRACE';
[a-zA-Z_][A-Za-z0-9_]*  return 'variable';
";"                     return 'SEMICOLON'

/lex



%start expressions

%%


expressions
    : declare EOF
        {  
            console.log($1); 
            return $1;
        }

    ;

declare
    : PROCEDURE variable LBRACE RBRACE SEMICOLON
        {
            console.log("in declare");

        }
    ;