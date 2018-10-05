use CommentableLanguage;
use Number;

grammar Lingua is CommentableLanguage does Number {
    # Language
    rule TOP {
        [
            | <one-line-comment>
            | <statement> ';'
        ]*
    }

    rule statement {
        | <variable-declaration>
        | <assignment>
        | <function-call>
    }

    rule variable-declaration {
        'my' <variable-name> [ '=' <expression> ]?
    }

    rule assignment {
        <variable-name> '=' <expression>
    }

    rule function-call {
        <function-name> <variable-name>
    }

    token variable-name {
        \w+
    }

    token function-name {
        'say'
    }

    # Calculator expressions
    rule expression {
        <term>+ %% <op(1)>
    }

    rule term {
        <factor>+ %% <op(2)>
    }

    rule factor {
        <value>+ %% <op(3)>
    }

    multi token op(1) {
        '+' | '-'
    }

    multi token op(2) {
        '*' | '/'
    }

    multi token op(3) {
        '**'
    }

    rule value {
        | <number>
        | <variable-name>
        | '(' <expression> ')'
    }
}
