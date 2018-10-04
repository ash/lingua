my %var;

class LinguaActions {
    # Language
    method variable-declaration($/) {
        %var{$<variable-name>} = 0;
    }

    method assignment($/) {
        %var{~$<variable-name>} = $<expression>.made;
    }

    method function-call($/) {
        say %var{$<variable-name>} if $<function-name> eq 'say';
    }

    # Calculator expressions
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
        $/.make($<number> ?? $<number>.made !! $<expression>.made);
    }

    # Numbers
    method number($/) {
        $/.make(+$/);
    }
}
