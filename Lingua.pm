grammar Lingua {
    rule TOP {
        [
            | <comment>
            | <statement> ';'
        ]*
    }

    rule statement {
        | <variable-declaration>
        | <assignment>
        | <function-call>
    }

    rule comment {
        '#' \N*
    }

    rule variable-declaration {
        'my' <variable-name>
    }

    rule assignment {
        <variable-name> '=' <value>
    }

    rule function-call {
        <function-name> <variable-name>
    }

    token variable-name {
        \w+
    }

    token value {
        \d+
    }

    token function-name {
        'say'
    }
}
