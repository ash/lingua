grammar Calculator {
    rule TOP {
        <number> [<op> <number> <ws>]*
    }

    token op {
        '+' | '-'
    }

    token number {
        \d+
    }
}

class CalculatorActions {
    multi sub operation('+', @values) {
        [+] @values
    }

    multi sub operation('-', @values) {
        [-] @values
    }

    method TOP($/) {
        if $<op> {
            $/.make(operation(~$<op>[0], $<number>.map: *.made));
        }
        else {
            $/.make($<number>[0].made);
        }
    }

    method number($/) {
        $/.make(+$/);
    }
}

my @cases =
    '3 + 4', '3 - 4',
    '7',
    '1 + 2 + 3', '1 + 3 + 5 + 7';
for @cases -> $test {
    say "$test = " ~ Calculator.parse($test, :actions(CalculatorActions)).made;
}
