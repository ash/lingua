grammar Calculator {
    rule TOP {
        <number>
    }

    token number {
        <[+-]>? \d* ['.' \d+]?
    }
}

my @cases =
    7, 77, -84, '+7', 0,
    3.14, -2.78, 5.0, '.5',
    '', '-', '+';
for @cases -> $expression {
    my $test = Calculator.parse($expression);
    say ($test ?? 'OK ' !! 'NOT OK ') ~ $expression;
}
