use Test;

grammar Calculator {
    rule TOP {
        <term>* %% <op1>
    }

    rule term {
        <factor>* %% <op2>
    }

    rule factor {
        <value>* %% <op3>
    }

    token op1 {
        '+' | '-'
    }

    token op2 {
        '*' | '/'
    }

    token op3 {
        '**'
    }

    rule value {
        | <number>
        | '(' <TOP> ')'
    }

    rule number {
        \d+
    }
    # token number {
    #     <ws> \d+ <ws>
    # }
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

    multi sub operation('**', $a is rw, $b) {
        $a **= $b
    }

    method TOP($/) {
        $/.make(process($<term>, $<op1>));
    }

    method term($/) {
        $/.make(process($<factor>, $<op2>));
    }

    method factor($/) {
        $/.make(process($<value>, $<op3>));
    }

    sub process(@data, @ops) {
        my @nums = @data.map: *.made;
        my $result = @nums.shift;

        operation(~@ops.shift, $result, @nums.shift) while @nums;

        return $result;
    }

    method value($/) {
        $/.make($<number> ?? $<number>.made !! $<TOP>.made);
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
    '1 + 2 - 3 * 4 / 5',
    '2 ** 3',
    '2 + 3 ** 4',
    '1 + 2 * 3 ** 4 - 5 * 6',
    '2 ** 3 ** 4',
    '10 * (20 - 30)', '10 * 20 - 30',
    '(5 * 6)', '(10)',
    '1 - (5 * (3 + 4)) / 2'
    ;

for @cases -> $test {
    my $parse = Calculator.parse($test, :actions(CalculatorActions));
    next unless isa-ok($parse, Match, "parsed $test");

    my $result = $parse.made;
    my $correct = EVAL($result);
    is($result, $correct, "computed $test = $correct");
}
