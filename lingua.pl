grammar Lingua {
    rule TOP {
        <statement>* %% ';'
    }

    rule statement {
        <-[;]>*
    }
}

my $code = 'test.lng'.IO.slurp();
my $result = Lingua.parse($code);
say $result;
