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

class LinguaActions {
    method variable-declaration($/) {
        %var{$<variable-name>} = 0;
    }

    method assignment($/) {
        %var{~$<variable-name>} = +$<value>;
    }

    method function-call($/) {
        say %var{$<variable-name>} if $<function-name> eq 'say';
    }
}

my $code = 'test2.lng'.IO.slurp();
my $result = Lingua.parse($code, :actions(LinguaActions));
#say $result;
#say %var;