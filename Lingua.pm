use CommentableLanguage;

grammar Lingua is CommentableLanguage {
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
        <term>* %% <op1>
    }

    rule term {
        <factor>* %% <op2>
    }

    rule factor {
        <value>* %% <op3>
    }

    token op1 {
        '+' | '-'
    }

    token op2 {
        '*' | '/'
    }

    token op3 {
        '**'
    }

    rule value {
        | <number>
        | <variable-name>
        | '(' <expression> ')'
    }

    # Numbers
    token number {
        <sign>? [
            | <integer>
            | <floating-point>
        ] <exponent>?
    }

    token sign {
        <[+-]>
    }

    token exp {
        <[eE]>
    }

    token integer {
        \d+
    }

    token floating-point {
        <integer>? ['.' <integer>]
    }

    token exponent {
        <exp> <sign>? <integer>
    }
}
