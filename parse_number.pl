grammar Number {
    rule TOP {
        <number>
    }

    token number {
        <sign>? [
            | <integer>
            | <floating-point>
        ] <exponent>?
    }

    token sign {
        <[+-]>
    }

    token exp {
        <[eE]>
    }

    token integer {
        \d+
    }

    token floating-point {
        \d* ['.' <integer>]
    }

    token exponent {
        <exp> <sign>? <integer>
    }
}

class NumberActions {
    has $.n = 0;
    has $!sign = 1;

    method integer($/) {
        $!n = $!sign * +$/;
    }

    method sign($/) {
        $!sign = -1 if ~$/ eq '-';
    }
}

my @cases =
    7, 77, -84, '+7', 0,
    3.14, -2.78, 5.0, '.5', '-5.3', '-.3',
    '3E4', '-33E55', '3E-3', '-1E-2',
    '3.14E2', '.5E-3',
    '', '-', '+';
for @cases -> $number {
    my $actions = NumberActions.new();
    my $test = Number.parse($number, :actions($actions));
    
    if ($test) {
        say "OK $number = " ~ $actions.n;
    }
    else {
        say "NOT OK $number";
    }
}
