use CommentableLanguage;
use Number;

grammar Lingua is CommentableLanguage does Number {
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
        <function-name> <expression>
    }

    token variable-name {
        [<:alpha> | '_'] \w*
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

    multi rule expr($n) {
        <expr($n + 1)>+ %% <op($n)>
    }

    multi rule expr(4) {
        | <number>
        | <string>
        | <variable-name>
        | '(' <expression> ')'
    }

    rule string {
        '"' ( <-["]>* ) '"'
    }
}
