grammar Calculator {
    rule TOP {
        <number> [<op> <number> <ws>]*
    }

    token op {
        '+' | '-' | '*' | '/'
    }

    token number {
        \d+
    }
}

class CalculatorActions {
    multi sub operation('+', $a is rw, $b) {
        $a += $b
    }

    multi sub operation('-', $a is rw, $b) {
        $a -= $b
    }

    multi sub operation('*', $a is rw, $b) {
        $a *= $b
    }

    multi sub operation('/', $a is rw, $b) {
        $a /= $b
    }

    method TOP($/) {
        my @numbers = $<number>.map: *.made;
        my $make = @numbers.shift;

        operation(~$<op>.shift, $make, @numbers.shift)
            while @numbers.elems;

        $/.make($make);
    }

    method number($/) {
        $/.make(+$/);
    }
}

my @cases =
    # '3 + 4', '3 - 4',
    # '7',
    # '1 + 2 + 3', '1 + 3 + 5 + 7',
    # '7 + 8 - 3', '14 - 4', '14 - 4 - 3',
    # '100 - 200 + 300 + 1 - 2'
    '3 * 4', '100 / 25',
    '1 + 2 * 3'
    ;

for @cases -> $test {
    say "$test = " ~ Calculator.parse($test, :actions(CalculatorActions)).made;
}
