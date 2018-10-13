#!/usr/bin/env perl6

my @ast = $*IN.lines();
my $ast = @ast[0];

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
