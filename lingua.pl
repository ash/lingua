grammar Lingua {
    rule TOP {
        ^ .* $
    }
}

my $code = 'test.lng'.IO.slurp();
my $result = Lingua.parse($code);
say $result;
