class LinguaActions {
    has %!var;

    method TOP($/) {
        dd %!var;
    }

    method scalar-declaration($/) {
        %!var{$<variable-name>} = $<value> ?? $<value>.made !! 0;
    }

    method init-array($variable-name, @values) {
        %!var{$variable-name} = $[];
        for @values -> $value {
            %!var{$variable-name}.push($value.made);
        }
    }

    multi method array-declaration($/ where !$<value>) {
        %!var{$<variable-name>} = $[];
    }

    multi method array-declaration($/ where $<value>) {
        self.init-array($<variable-name>, $<value>);
    }

    multi method assignment($/ where $<index>) {
        %!var{$<variable-name>}[$<index>.made] = $<value>[0].made;
    }

    multi method assignment($/ where !$<index>) {
        if %!var{$<variable-name>} ~~ Array {
            self.init-array($<variable-name>, $<value>);
        }
        else {
            %!var{$<variable-name>} = $<value>[0].made;
        }
    }

    method index($/) {
        $/.make(+$<integer>);
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

    multi method value($/ where $<expression>) {
        $/.make($<expression>.made);
    }

    multi method value($/ where $<string>) {
        $/.make($<string>.made);
    }

    method expression($/) {
        $/.make($<expr>.made);
    }

    multi method expr($/ where $<number>) {
        $/.make($<number>.made);
    }

    multi method expr($/ where $<string>) {
        $/.make($<string>.made);
    }

    multi method expr($/ where $<variable-name> && $<index>) {
        if %!var{$<variable-name>} ~~ Array {
            $/.make(%!var{$<variable-name>}[$<index>.made]);
        }
        else {
            $/.make(%!var{$<variable-name>}.substr($<index>.made, 1));
        }
    }

    multi method expr($/ where $<variable-name> && !$<index>) {
        $/.make(%!var{$<variable-name>});
    }

    multi method expr($/ where $<expr>) {
        $/.make(process($<expr>, $<op>));
    }

    multi method expr($/ where $<expression>) {
        $/.make($<expression>.made);
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

        for $a[0]<variable-name>.reverse -> $var {
            $s.substr-rw($var.from - $a.from - 2, $var.pos - $var.from + 1) = %!var{$var};
        }

        $s ~~ s:g/\\\"/"/;
        $s ~~ s:g/\\\\/\\/;
        $s ~~ s:g/\\\$/\$/;

        $a.make($s);
    }
}
