use LinguaAST;

class LinguaActions {
    has %!var;

    method TOP($/) {
        my $top = AST::TOP.new;
        for $<statement> -> $statement {
            $top.statements.push($statement.made);
        }

        dd $top;
        $/.make($top);
    }

    method statement($/) {
        $/.make($<statement>.made);
    }

    multi method variable-declaration($/) {
        $/.make($<declaration>.made);
    }

    method scalar-declaration($/) {
        $/.make(AST::ScalarDeclaration.new(
            variable-name => ~$<variable-name>,
            value => $<value> ?? $<value>.made !! AST::Null.new(),
        ));
    }

    multi method array-declaration($/ where !$<value>) {
        $/.make(AST::ArrayDeclaration.new(
            variable-name => ~$<variable-name>,
            elements => []
        ));
    }

    sub init-array($variable-name, $elements) {
        return AST::ArrayAssignment.new(
            variable-name => $variable-name,
            elements => $elements.map: *.made
        );
    }

    multi method array-declaration($/ where $<value>) {
        $/.make(init-array(~$<variable-name>, $<value>));
    }

    multi method hash-declaration($/ where !$<string>) {
        $/.make(AST::HashDeclaration.new(
            variable-name => ~$<variable-name>,
            elements => {}
        ));
    }

    sub init-hash($variable-name, $keys, $values) {
        return AST::HashAssignment.new(
            variable-name => $variable-name,
            keys => ($keys.map: *.made.value),
            values => ($values.map: *.made)
        );
    }

    multi method hash-declaration($/ where $<string> && $<value>) {
        $/.make(init-hash(~$<variable-name>, $<string>, $<value>));
    }

    multi method assignment($/ where $<index> && $<index><array-index>) {
        $/.make(AST::ArrayItemAssignment.new(
            variable-name => ~$<variable-name>,
            index => $<index>.made,
            rhs => $<value>[0].made
        ));
    }

    multi method assignment($/ where $<index> && $<index><hash-index>) {
        $/.make(AST::HashItemAssignment.new(
            variable-name => ~$<variable-name>,
            key => $<index>.made.value,
            rhs => $<value>[0].made
        ));
    }

    multi method assignment($/ where !$<index> && !$<value>) {
        $/.make(AST::ScalarAssignment.new(
            variable-name => ~$<variable-name>,
            rhs => $<value>[0].made
        ));
    }

    multi method assignment($/ where !$<index> && $<value> && !$<string>) {
        $/.make(init-array(~$<variable-name>, $<value>));
    }

    multi method assignment($/ where !$<index> && $<value> && $<string>) {
        $/.make(init-hash(~$<variable-name>, $<string>, $<value>));
    }

    multi method index($/ where $<array-index>) {
        $/.make($<array-index>.made);
    }

    multi method index($/ where $<hash-index>) {
        $/.make($<hash-index>.made);
    }

    multi method array-index($/ where !$<variable-name>) {
        $/.make(+$<integer>);
    }

    multi method array-index($/ where $<variable-name>) {
        $/.make(%!var{$<variable-name>});
    }

    multi method hash-index($/ where !$<variable-name>) {
        $/.make($<string>.made);
    }

    multi method hash-index($/ where $<variable-name>) {
        $/.make(%!var{$<variable-name>});
    }

    method function-call($/) {
        if $<variable-name> {
            my $condition = %!var{$<variable-name>};
            return unless $condition;
        }

        my $object = $<value>.made;

        if $object ~~ Array {
            say $object.join(q{, });
        }
        elsif $object ~~ Hash {
            my @str;
            for $object.keys.sort -> $key {
                @str.push("$key: $object{$key}");
            }
            say @str.join(q{, });
        }
        else {            
            say $object;
        }
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
        $/.make(AST::Variable.new(
            variable-name => ~$<variable-name>
        ));
    }

    multi method expr($/ where $<expr> && !$<op>) {
        $/.make(AST::NumberValue.new(
            value => $<expr>[0].made.value
        ));
    }

    multi method expr($/ where $<expr> && $<op>) {
        $/.make(AST::MathOperations.new(
            operators => ($<op>.map: ~*),
            operands => ($<expr>.map: *.made)
        ));
    }

    multi method expr($/ where $<expression>) {
        $/.make($<expression>.made);
    }

    method number($/) {
        $/.make(AST::NumberValue.new(
            value => +$/
        ));
    }

    method string($a) {
        my $s = ~$a[0];

        for $a[0]<variable-name>.reverse -> $var {
            $s.substr-rw($var.from - $a.from - 2, $var.pos - $var.from + 1) = %!var{$var};
        }

        $s ~~ s:g/\\\"/"/;
        $s ~~ s:g/\\\\/\\/;
        $s ~~ s:g/\\\$/\$/;

        $a.make(AST::StringValue.new(value => $s));
    }
}
