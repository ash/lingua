grammar Calculator {
    rule TOP {
        <number>
    }

    token number {
        <[+-]>? \d+
    }
}

my @cases = 7, 77, -84, '+7', 0;
for @cases -> $expression {
    my $test = Calculator.parse($expression);
    say ($test ?? 'OK ' !! 'NOT OK ') ~ $expression;
}
