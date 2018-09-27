grammar Calculator {
    rule TOP {
        <number>
    }

    token number {
        '-'? \d+
    }
}

my @cases = 7, 77, -84;
for @cases -> $expression {
    say "Test $expression";
    say Calculator.parse($expression);
}
