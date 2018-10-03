use Lingua;
use LinguaActions;

my $code = 'test3.lng'.IO.slurp();
Lingua.parse($code, :actions(LinguaActions));
