
/* from https://github.com/Octachron/talaria_bibtex/blob/master/src/parser.mly */

%token <string> TEXT
%token <string> KIND
%token LCURL COMMA RCURL EQUAL EOF

%type <string * string * (string * string) list> entry
%type <(string * string * (string * string) list) list> entries

%start entry
%start entries

%{

type entry = (string * string) list
type bibtex = entry list

%}

%%

%public entries:
  | l=entry* EOF { l }

%public entry:
  | kind_v=KIND LCURL name=TEXT COMMA e=fields RCURL { name, kind_v, e }

fields:
  | l=separated_nonempty_list(COMMA, field) { l }

field:
  | key=TEXT EQUAL LCURL p=rtext RCURL COMMA { (key, p) }

rtext:
  | s=TEXT {s}
  | s=TEXT EQUAL rs=rtext {s^"="^rs}
  | s1=TEXT COMMA rs=rtext  {s1 ^","^ rs }
  | LCURL s1=TEXT RCURL rs=rtext {s1 ^ rs }

