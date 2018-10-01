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
    method TOP($/) {
        if $<op> eq '+' {
            $/.make($<number>[0].made + $<number>[1].made);
        }
        else {
            $/.make($<number>[0].made - $<number>[1].made);
        }
    }

    method number($/) {
        $/.make(+$/);
    }
}

my @cases = '3 + 4', '3 - 4';
for @cases -> $test {
    say "$test = " ~ Calculator.parse($test, :actions(CalculatorActions)).made;
}
