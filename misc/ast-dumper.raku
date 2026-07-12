#!/usr/bin/env raku

# Run it as:
# ./lingua play/test43.lng 2>&1 | ./misc/ast-dumper.raku

my @ast = $*IN.lines();

for @ast -> $ast is rw {
    my $level = 0;
    my $indent = '  ';
    $ast ~~ s:g/', '/,/;
    for $ast.comb -> $char {
        if $char eq '(' {
            $level++;
            print $char;
            nl();
        }
        elsif $char eq ')' {
            $level--;
            nl();
            print $char;
        }
        elsif $char eq ',' {
            print $char;
            nl();
        }
        else {
            print $char;
        }
    }
    sub nl() {
        print "\n", $indent x $level;
    }
    ''.say;
}