grammar Calculator {
    rule TOP {
        <number> '+' <number>
    }

    token number {
        \d+
    }
}

class CalculatorActions {
    method TOP($/) {
        $/.make($<number>[0].made + $<number>[1].made);
    }

    method number($/) {
        $/.make(+$/);
    }
}

Calculator.parse('3 + 4', :actions(CalculatorActions)).made.say;
