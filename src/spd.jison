/** spd file parse jison
 *
 */
%lex

%%

\s+       /* skip white space  */
'/*'[\s\S]*?'*/'        /* skip comment */;
"SERVICES"        return 'startService';
SYNC|ASYNC        return 'serverType';

"PROCEDURE"       return 'PROCEDURE';
"LIBRARY"         return 'lib';
"ENDLIBRARY"      return 'endLib';
","               return 'COMMA';
"("               return 'LBRACE';
")"               return 'RBRACE';
"->"              return 'SARROW';
"=>"|"<="         return 'DARROW';
"IN/OUT"          return 'inout';
"IN"              return 'in';
"OUT"             return 'out';
FAR|NEAR          return 'dist';
"COMMENT"         return 'comment';
\'[^\']*\'        return 'string';
<<EOF>>                 return 'EOF';
[a-zA-Z_][A-Za-z0-9_]*  return 'variable';
";"                     return 'SEMICOLON'
"..."                   return 'dot3';
/lex

%right declares


%start expressions

%% /* language grammar */

expressions
  :libdef declares endlibdef EOF
    {
      return $2.slice();
    }
  | libdef declares EOF
    {
      return $2.slice();
    }
  | declares EOF
    {
      return $1;
    }
  ;

parameter
  : in variable variable
    { $$ = {dir:'in',name:$2, type: $3} }
  | variable variable
    { $$ = {dir:'in',name:$1, type: $2} }
  | out variable variable
    { $$ = {dir:'out',name:$2, type: $3} }
  | inout dist variable variable
    { $$ = {dir:'inout',name:$3, type: $4} }
  | inout variable variable
    { $$ = {dir:'inout',name:$2, type: $3} }
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

arg
  : LBRACE parameters RBRACE
    {
      $$ = $2.slice();
    }
  | LBRACE parameters COMMA dot3 RBRACE
    {
      $$ = $2.slice();
    }
  | LBRACE RBRACE
    {
      $$ = [];
    }
  ;

statementComment
  : comment strings  SEMICOLON
  | SEMICOLON
  ;

procedureName
  : PROCEDURE variable
    {
      $$ = $2;
    }
  | variable
    {
      $$ = $1;
    }
  ;


strings
  : strings string
  | string
  ;

declares
  : declares declare
    {
      $1.push($2)
      $$ = $1.slice();
    }
  | declare
    {
      $$ = [ $1 ];
    }
  ;

distDefine
  : dist DARROW
  | dist
  ;

declare
  : procedureName arg SARROW COMMA distDefine statementComment
    {
      $$ = {name: $1,return:'',parameters:$2};
    }
  | procedureName arg SARROW variable COMMA distDefine statementComment
    {
      $$ = {name: $1,return:$4,parameters:$2};
    }
  ;

libdef
  : startService serverType lib variable SEMICOLON
  | startService serverType
  ;
endlibdef
  : endLib variable statementComment
  ;
