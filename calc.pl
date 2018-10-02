use Test;

grammar Calculator {
    rule TOP {
        <term>* %% <op1>
    }

    rule term {
        <factor>* %% <op2>
    }

    token op1 {
        '+' | '-'
    }

    token op2 {
        '*' | '/'
    }

    rule factor {
        <number>
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
        $/.make(process($<term>, $<op1>));
    }

    method term($/) {
        $/.make(process($<factor>, $<op2>));
    }

    sub process(@data, @ops) {
        my @nums = @data.map: *.made;
        my $result = @nums.shift;

        operation(~@ops.shift, $result, @nums.shift) while @nums;

        return $result;
    }

    method factor($/) {
        $/.make($<number>.made);
    }

    method number($/) {
        $/.make(+$/);
    }
}

my @cases =
    '3 + 4', '3 - 4',
    '7',
    '1 + 2 + 3', '1 + 3 + 5 + 7',
    '7 + 8 - 3', '14 - 4', '14 - 4 - 3',
    '100 - 200 + 300 + 1 - 2',
    '3 * 4', '100 / 25',
    '1 + 2 * 3',
    '1 + 2 - 3 * 4 / 5'
    ;

for @cases -> $test {
    my $result = Calculator.parse($test, :actions(CalculatorActions)).made;
    my $correct = EVAL($result);
    is($result, $correct, "$test = $correct");
}
