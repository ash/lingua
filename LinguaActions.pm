my %var;

class LinguaActions {
    method variable-declaration($/) {
        %var{$<variable-name>} = 0;
    }

    method assignment($/) {
        %var{~$<variable-name>} = +$<value>;
    }

    method function-call($/) {
        say %var{$<variable-name>} if $<function-name> eq 'say';
    }
}
