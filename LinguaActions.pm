class LinguaActions {
    has %!var;

    method variable-declaration($/) {
        %!var{$<variable-name>} = $<value> ?? $<value>.made !! 0;
    }

    method assignment($/) {
        %!var{~$<variable-name>} = $<value>.made;
    }

    method function-call($/) {
        say $<value>.made;
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

    method value($/) {
        if $<expression> {
            $/.make($<expression>.made);
        }
        elsif $<string> {
            $/.make($<string>.made);
        }
    }

    method expression($/) {
        $/.make($<expr>.made);
    }

    method expr($/) {
        if $<number> {
            $/.make($<number>.made);
        }
        elsif $<string> {
            $/.make($<string>.made);
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

    method string($a) {
        my $s = ~$a[0];
        $s ~~ s/\\\"/"/;
        $s ~~ s:g/\\\\/\\/;
        $a.make($s);
    }
}
