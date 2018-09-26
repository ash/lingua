grammar Lingua {
    rule TOP {
        <statement>* %% ';'
    }

    rule statement {
        | <variable-declaration>
        | <assignment>
        | <function-call>
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

my $code = 'test.lng'.IO.slurp();
my $result = Lingua.parse($code);
say $result;
