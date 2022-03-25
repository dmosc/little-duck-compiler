%lex
%%
"+" { return "PLUS"; }
"-" { return "MINUS"; }
"*" { return "MULTIPLICATION"; }
"/" { return "DIVISION"; }
">" { return "GT"; }
">=" { return "GTE"; }
"<" { return "LT"; }
"<=" { return "LTE"; }
"<>" { return "NE"; }
"=" { return "EQUAL"; }
"(" { return "OPEN_PARENTHESIS"; }
")" { return "CLOSED_PARENTHESIS"; }
"{" { return "OPEN_BRACKET"; }
"}" { return "CLOSED_BRACKET"; }
"," { return "COMMA"; }
";" { return "SEMICOLON"; }
":" { return "COLON"; }
if { return "IF"; }
else { return "ELSE"; }
var { return "VAR"; }
int { return "INT_TYPE"; }
float { return "FLOAT_TYPE"; }
print { return "PRINT"; }
program { return "PROGRAM"; }

[0-9]+\.[0-9]+ { return "FLOAT"; }
[0-9]+ { return "INT"; }
[A-z][A-z0-9]+ { return "ID"; }
\".*\" { return "STRING"; }
[\n] {}
. {}

/lex

%left "+" "-"
%left "*" "/"
%start program

%%

program:
    PROGRAM ID SEMICOLON program_s1 block {
        console.log(`🦆 Processed ${this._$.last_line} lines.`);
    };

program_s1: /* empty */
    |
    vars |
    statement;

block:
    OPEN_BRACKET block_s1 CLOSED_BRACKET;

block_s1: /* empty */
    |
    statement block_s1;

vars:
    VAR ID vars_s1 COLON type SEMICOLON vars_s2;

vars_s1: /* empty */
    |
    COMMA ID vars_s1;

vars_s2: /* empty */
    |
    ID vars_s1 COLON type SEMICOLON vars_s2;

type:
    INT_TYPE |
    FLOAT_TYPE;

statement:
    assignment |
    condition |
    write;

assignment:
    ID EQUAL expression SEMICOLON;

expression:
    exp expression_s1;

expression_s1: /* empty */
    |
    comparison exp;

exp:
    term exp_s1;

exp_s1: /* empty */
    |
    sign term exp_s1;

term:
    factor term_s1;

term_s1: /* empty */
    |
    operator factor term_s1;

factor:
    OPEN_PARENTHESIS expression CLOSED_PARENTHESIS |
    factor_s1;

factor_s1:
    sign value |
    value;

value:
    ID |
    INT |
    FLOAT;

condition:
    IF OPEN_PARENTHESIS expression CLOSED_PARENTHESIS block condition_s1;

condition_s1:
    SEMICOLON |
    ELSE block SEMICOLON;

write:
    PRINT OPEN_PARENTHESIS write_s1 CLOSED_PARENTHESIS SEMICOLON;

write_s1:
    expression write_s2 |
    STRING write_s2;

write_s2: /* empty */
    |
    COMMA write_s1;

operator:
    MULTIPLICATION |
    DIVISION;

sign:
    PLUS |
    MINUS;

comparison:
    GT |
    GTE |
    LT |
    LTE |
    NE;