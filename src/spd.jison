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

  : declares EOF
    {
      return $1;
    }
    ;

parameter
  : in variable variable
    { $$ = {dir:'in',name:$2, type: $3} }
  | out variable variable
    { $$ = {dir:'out',name:$2, type: $3} }
  ;

parameters
  : parameter
      { $$ = [ $1 ] }
  | parameters COMMA parameter
    {
      $1.push($3);
      $$ = $1.slice();
    }
  ;

strings
  : string
  | strings string
  ;

declares
  : declare
    {
      $$ = [ $1 ];
    }
  | declares declare
    {

      $1.push($2)

      $$ = $1.slice();
    }
  ;

declare
  : PROCEDURE variable LBRACE RBRACE SARROW COMMA dist DARROW SEMICOLON
    {
      $$ = {name: $2};
    }
  | PROCEDURE variable LBRACE RBRACE SARROW COMMA dist DARROW  comment strings SEMICOLON
    {
      $$ = {name: $2};
    }
  | PROCEDURE variable LBRACE parameters RBRACE SARROW COMMA dist DARROW SEMICOLON
    {
      $$ = {name: $2,parameters:$4};
    }
  ;


