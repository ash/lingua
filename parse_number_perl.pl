grammar Number {
    token TOP {
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
        <integer>? ['.' <integer>]
    }

    token exponent {
        <exp> <sign>? <integer>
    }
}

class NumberActions {
    method TOP($/) {
        my $n = $<integer> ?? $<integer>.made !! $<floating-point>.made;
        $n *= $<sign>.made if $<sign>;
        $n *= 10 ** $<exponent>.made if $<exponent>;
        $/.make($n);
    }

    method integer($/) {
        $/.make(+$/);
    }

    method floating-point($/) {
        $/.make(+$/);
    }

    method sign($/) {
        $/.make(~$/ eq '-' ?? -1 !! 1);
    }

    method exponent($/) {
        my $e = $<integer>;
        $e *= -1 if $<sign> && ~$<sign> eq '-';
        $/.make($e);
    }
}

my @cases =
    7, 77, -84, '+7', 0,
    3.14, -2.78, '5.0', '.5', '-5.3', '-.3',
    '3E4', '-33E55', '3E-3', '-1E-2',
    '3.14E2', '.5E-3',
    '', '-', '+';

for @cases -> $number {
    my $actions = NumberActions.new();
    my $test = Number.parse($number, :actions($actions));
    #dd $test;
    
    if ($test) {
        say "OK $number = " ~ $test.made ~ ' (' ~ $test.made.^name ~ ')';
    }
    else {
        say "NOT OK $number";
    }
}
