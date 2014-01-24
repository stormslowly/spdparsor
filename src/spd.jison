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
"=>"              return 'DARROW';
"IN/OUT"          return 'inout';
"IN"              return 'in';
"OUT"             return 'out';
FAR|NEAR          return 'dist';
"COMMENT"         return 'comment';
\'[^\']*\'        return 'string';
<<EOF>>                 return 'EOF';
[a-zA-Z_][A-Za-z0-9_]*  return 'variable';
";"                     return 'SEMICOLON'

/lex

%right declares


%start expressions

%% /* language grammar */

expressions
  :
  libdef declares endlibdef EOF
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

declare
  : PROCEDURE variable LBRACE RBRACE SARROW COMMA dist DARROW SEMICOLON
    {
      $$ = {name: $2,return:''};
    }
  | PROCEDURE variable LBRACE RBRACE SARROW COMMA dist DARROW  comment strings SEMICOLON
    {
      $$ = {name: $2,return:''};
    }
  | PROCEDURE variable LBRACE parameters RBRACE SARROW COMMA dist DARROW SEMICOLON
    {
      $$ = {name: $2,parameters:$4,return:''};
    }
  | PROCEDURE variable LBRACE parameters RBRACE SARROW COMMA dist DARROW comment strings SEMICOLON
    {
      $$ = {name: $2,parameters:$4,return:''};
    }
  | PROCEDURE variable LBRACE RBRACE SARROW variable COMMA dist DARROW SEMICOLON
    {
      $$ = {name: $2,return:$6};
    }
  | PROCEDURE variable LBRACE RBRACE SARROW variable COMMA dist DARROW  comment strings SEMICOLON
    {
      $$ = {name: $2,return:$6};
    }
  | PROCEDURE variable LBRACE parameters RBRACE SARROW variable COMMA dist DARROW SEMICOLON
    {
      $$ = {name: $2,parameters:$4,return:$7};
    }
  | PROCEDURE variable LBRACE parameters RBRACE SARROW variable COMMA dist DARROW comment strings SEMICOLON
    {
      $$ = {name: $2,parameters:$4,return:$7};
    }
  ;

libdef
  : startService serverType lib variable SEMICOLON
  ;
endlibdef
  : endLib variable SEMICOLON
  ;
