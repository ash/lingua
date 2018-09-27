use Lingua;
use LinguaActions;

my $code = 'test2.lng'.IO.slurp();
Lingua.parse($code, :actions(LinguaActions));
