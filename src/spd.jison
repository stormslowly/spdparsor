/** spd file parse jison
 *
 */



 %lex 

%%

\s+       /* skip white space  */
SERVICES  /* skip the service  */
SYNC      /* skip the sync     */

"PROCEDURE"       return 'PROCEDURE';
","               return 'COMMA';
"("               return 'LBRACE';
")"               return 'RBRACE';
"->"              return 'SARROW';
"=>"              return 'DARROW';

<<EOF>>                 return 'EOF';
[a-zA-Z_][A-Za-z0-9_]*  return 'variable';
";"                     return 'SEMICOLON'

/lex



%start expressions

%% /* language grammar */

expressions
    : declare EOF
        {  
            console.log("expressions==",$1); 
            return $1;
        }

    ;

declare
    : PROCEDURE variable LBRACE RBRACE SARROW COMMA DARROW variable SEMICOLON
      {
      	console.log($2);
      	$$ = {name: $2};
      }
    ;