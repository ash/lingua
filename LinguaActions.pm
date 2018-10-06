class LinguaActions {
    has %!var;

    method variable-declaration($/) {
        %!var{$<variable-name>} = $<expression> ?? $<expression>.made !! 0;
    }

    method assignment($/) {
        %!var{~$<variable-name>} = $<expression>.made;
    }

    method function-call($/) {
        say %!var{$<variable-name>} if $<function-name> eq 'say';
    }

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

    method expression($/) {
        $/.make($<expr>.made);
    }

    method expr($/) {
        if $<number> {
            $/.make($<number>.made);
        }
        elsif $<variable-name> {
            $/.make(%!var{$<variable-name>});
        }
        elsif $<expr> {
            $/.make(process($<expr>, $<op>));
        }
        else {
            $/.make($<expression>.made);
        }
    }

    sub process(@data, @ops) {
        my @nums = @data.map: *.made;
        my $result = @nums.shift;

        operation(~@ops.shift, $result, @nums.shift) while @nums;

        return $result;
    }

    method number($/) {
        $/.make(+$/);
    }
}
