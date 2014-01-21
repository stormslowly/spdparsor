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
FAR|NEAR          return 'dist';
"COMMENT"         return 'comment';
\/\*.*\*\/        /* skip comment */
\'.*\'            return 'string';

<<EOF>>                 return 'EOF';
[a-zA-Z_][A-Za-z0-9_]*  return 'variable';
";"                     return 'SEMICOLON'

/lex



%start expressions

%% /* language grammar */

expressions

	: declare EOF
		{
            return $1;
		}
    ;

parameters
	: in variable variable
	    { $$ = [ {dir:'in',name:$2, type: $3}] }
	| out variable variable
		{ $$ = [ {dir:'out',name:$2, type: $3}] }
	| parameters COMMA parameters
		{
			for(var i = 0;i<$3.length; i+=1){
				$1.push($3[i]);
			}
			$$ = $1.slice();
		}

	;
strings
    : string
    | strings string
    ;

declare
    : PROCEDURE variable LBRACE RBRACE SARROW COMMA dist DARROW SEMICOLON
      {
      	/* console.log($2); */
      	$$ = [{name: $2}];
      }
    | PROCEDURE variable LBRACE RBRACE SARROW COMMA dist DARROW  comment strings SEMICOLON
      {
        /* console.log($2); */
        $$ = [{name: $2}];
      }
    | PROCEDURE variable LBRACE parameters RBRACE SARROW COMMA dist DARROW SEMICOLON
      {
      	/* console.log($2,$4); */
      	$$ = [{name: $2,parameters:$4}];
      }
    | declare declare
    	{
    		for(var i = 0; i <$2.length;i+=1){
    			$1.push($2[i])
    		}
    		$$ = $1.slice();
    	}

    ;



