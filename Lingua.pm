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

    multi token op(1) {
        '+' | '-'
    }

    multi token op(2) {
        '*' | '/'
    }

    multi token op(3) {
        '**'
    }

    rule expression {
        <expr(1)>
    }

    multi rule expr(1) {
        <expr(2)>+ %% <op(1)>
    }

    multi rule expr(2) {
        <expr(3)>+ %% <op(2)>
    }

    multi rule expr(3) {
        <expr(4)>+ %% <op(3)>
    }

    multi rule expr(4) {
        | <number>
        | <variable-name>
        | '(' <expression> ')'
    }
}
