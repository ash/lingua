class LinguaActions {
    has %!var;

    method scalar-declaration($/) {
        %!var{$<variable-name>} = $<value> ?? $<value>.made !! 0;
    }

    method init-array($variable-name, @values) {
        %!var{$variable-name} = Array.new;
        for @values -> $value {
            %!var{$variable-name}.push($value.made);
        }
    }

    multi method array-declaration($/ where !$<value>) {
        %!var{$<variable-name>} = Array.new;
    }

    multi method array-declaration($/ where $<value>) {
        self.init-array($<variable-name>, $<value>);
    }

    method init-hash($variable-name, @keys, @values) {
        %!var{$variable-name} = Hash.new;
        while @keys {
            %!var{$variable-name}.{@keys.shift.made} = @values.shift.made;
        }
    }

    multi method hash-declaration($/) {
        self.init-hash($<variable-name>, $<string>, $<value>);
    }

    multi method assignment($/ where $<index> && $<index><array-index>) {
        %!var{$<variable-name>}[$<index>.made] = $<value>[0].made;
    }

    multi method assignment($/ where $<index> && $<index><hash-index>) {
        %!var{$<variable-name>}{$<index>.made} = $<value>[0].made;
    }

    multi method assignment($/ where !$<index>) {
        if %!var{$<variable-name>} ~~ Array {
            self.init-array($<variable-name>, $<value>);
        }
        elsif %!var{$<variable-name>} ~~ Hash {
            self.init-hash($<variable-name>, $<string>, $<value>);
        }
        else {
            %!var{$<variable-name>} = $<value>[0].made;
        }
    }

    multi method index($/ where $<array-index>) {
        $/.make($<array-index>.made);
    }

    multi method index($/ where $<hash-index>) {
        $/.make($<hash-index>.made);
    }

    method array-index($/) {
        $/.make(+$<integer>);
    }

    method hash-index($/) {
        $/.make($<string>.made);
    }

    method function-call($/) {
        my $object = $<value>.made;

        if $object ~~ Array {
            say $object.join(', ');
        }
        elsif $object ~~ Hash {
            my @str;
            for $object.keys.sort -> $key {
                @str.push("$key: $object{$key}");
            }
            say @str.join(', ');
        }
        else {            
            say $object;
        }
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
        elsif %!var{$<variable-name>} ~~ Hash {
            $/.make(%!var{$<variable-name>}{$<index>.made});
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
