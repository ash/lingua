grammar Calculator {
    rule TOP {
        | <addition>
        | <subtraction>
    }

    rule addition {
        <number> '+' <number>
    }

    rule subtraction {
        <number> '-' <number>
    }

    token number {
        \d+
    }
}

class CalculatorActions {
    method TOP($/) {
        $/.make($<addition> ?? $<addition>.made !! $<subtraction>.made);
    }

    method addition($/) {
        $/.make($<number>[0].made + $<number>[1].made);
    }

    method subtraction($/) {
        $/.make($<number>[0].made - $<number>[1].made);
    }

    method number($/) {
        $/.make(+$/);
    }
}

my @cases = '3 + 4', '3 - 4';
for @cases -> $test {
    say "$test = " ~ Calculator.parse($test, :actions(CalculatorActions)).made;
}
