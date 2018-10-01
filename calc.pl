grammar Calculator {
    rule TOP {
        <number> <op> <number>
    }

    token op {
        '+' | '-'
    }

    token number {
        \d+
    }
}

class CalculatorActions {
    my %operation =
        '+' => &addition,
        '-' => &subtraction;

    sub addition($a, $b) {
        $a + $b
    }

    sub subtraction($a, $b) {
        $a - $b
    }

    method TOP($/) {
        $/.make(%operation{~$<op>}($<number>[0].made, $<number>[1].made));
    }

    method number($/) {
        $/.make(+$/);
    }
}

my @cases = '3 + 4', '3 - 4';
for @cases -> $test {
    say "$test = " ~ Calculator.parse($test, :actions(CalculatorActions)).made;
}
