grammar Calculator {
    rule TOP {
        <number>
    }

    token number {
        <[+-]>? [
            | \d+
            | \d* ['.' \d+]
            | \d+ <[eE]> <[+-]>? \d+
        ]
    }
}

my @cases =
    7, 77, -84, '+7', 0,
    3.14, -2.78, 5.0, '.5', '-5.3', '-.3',
    '3E4', '-33E55', '3E-3', '-1E-2',
    '', '-', '+';
for @cases -> $expression {
    my $test = Calculator.parse($expression);
    say ($test ?? 'OK ' !! 'NOT OK ') ~ $expression;
}
