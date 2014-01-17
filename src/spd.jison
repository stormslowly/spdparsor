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
"IN"              return 'in';
"OUT"             return 'out';

<<EOF>>                 return 'EOF';
[a-zA-Z_][A-Za-z0-9_]*  return 'variable';
";"                     return 'SEMICOLON'

/lex



%start expressions

%% /* language grammar */

expressions
    : declare EOF
        {  
            /* console.log("expressions==",$1); */
            return $1;
        }

    ;

parameters
	: in variable variable
	    { $$ = [ {dir:'in',name:$2, type: $3}] }
	| out variable variable
		{ $$ = [ {dir:'out',name:$2, type: $3}] }
	| parameters COMMA in variable variable
		{
			$1.push( {dir:'in',name:$4, type: $5} );
			$$ = $1.slice();
		}
	| parameters COMMA out variable variable
		{ 
			$1.push( {dir:'out',name:$4, type: $5} );
			$$ = $1.slice();
		}
	;

declare
    : PROCEDURE variable LBRACE RBRACE SARROW COMMA DARROW variable SEMICOLON
      {
      	/* console.log($2); */
      	$$ = {name: $2};
      }
    | PROCEDURE variable LBRACE parameters RBRACE SARROW COMMA DARROW variable SEMICOLON
      {
      	/* console.log($2,$4); */
      	$$ = {name: $2,parameters:$4};
      }
    ;



