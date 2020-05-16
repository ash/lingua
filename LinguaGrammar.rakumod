use CommentableLanguage;
use Number;

grammar Lingua is CommentableLanguage does Number {
    rule TOP {
        [
            | <one-line-comment>
            | <statement=conditional-statement>
            | <statement=loopped-statement>
            | <statement=while-statement>
            | <statement> ';'
        ]*
    }

    rule conditional-statement {
        | 'if' <value> <block()> 'else' <block(';')>
        | 'if' <value> <block(';')>
    }

    rule loopped-statement {
        'loop' <variable-name> <block(';')>
    }

    rule while-statement {
        'while' <value> <block(';')>
    }

    multi rule block() {
        | '{' ~ '}' <statement> * %% ';'
        | <statement>
        
    }

    multi rule block(';') {
        | '{' ~ '}' <statement>* %% ';'
        | <statement> ';'
        
    }

    rule statement {
        | <statement=variable-declaration>
        | <statement=assignment>
        | <statement=function-call>
    }

    rule variable-declaration {
        'my' [
            | <declaration=array-declaration>
            | <declaration=hash-declaration>
            | <declaration=scalar-declaration>
        ]
    }

    rule array-declaration {
        <variable-name> '[' ']' [ '=' <value>+ %% ',' ]?
    }

    rule hash-declaration {
        <variable-name> '{' '}' [
            '=' [ <string> ':' <value> ]+ %% ','
        ]?
    }

    rule scalar-declaration {
        <variable-name> [ '=' <value> ]?
    }

    rule assignment {
        <variable-name> <index>? '='
            [
                | [ <string> ':' <value> ]+ %% ','
                |                <value>+   %% ','
            ]
    }

    rule index {
        | <array-index>
        | <hash-index>
    }

    rule array-index {
        '[' [ <integer> | <variable-name> ] ']'
    }

    rule hash-index {
        '{' [ <string> | <variable-name> ] '}'
    }

    rule function-call {
        <function-name> <value>
    }

    rule value {
        | <expression>
        | <string>
        | <function-call>
    }

    token variable-name {
        [<:alpha> | '_'] \w*
    }

    token function-name {
        'say' | 'print' | 'len' | 'keys'
    }

    multi token op(1) {
        | '|'
        | '<' | '>'
        | '<=' | '>='
        | '==' | '!='
    }

    multi token op(2) {
        '&'
    }

    multi token op(3) {
        '+' | '-'
    }

    multi token op(4) {
        '*' | '/'
    }

    multi token op(5) {
        '**'
    }

    rule expression {
        <expr(1)>
    }

    multi rule expr($n) {
        <expr($n + 1)>+ %% <op($n)>
    }

    multi rule expr(6) {
        | <number>
        | <variable-name> <index>?
        | '(' <expression> ')'
    }

    token string {
        '"' ( [
              | <-["\\$]>+
              | '\\"'
              | '\\\\'
              | '\\$'
              | '$' <variable-name>
              ]* )
        '"'
    }
}
