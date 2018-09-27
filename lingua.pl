my %var;

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
        'my' <variable-name> {
            %var{$<variable-name>} = 0;
        }
    }

    rule assignment {
        <variable-name> '=' <value> {
            %var{~$<variable-name>} = +$<value>;
        }
    }

    rule function-call {
        <function-name> <variable-name> {
            say %var{$<variable-name>} if $<function-name> eq 'say';
        }
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
#say $result;

say %var;