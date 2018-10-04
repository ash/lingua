use Lingua;
use LinguaActions;

my $code = 'test4.lng'.IO.slurp();
my $result = Lingua.parse($code, :actions(LinguaActions));
say $result ?? 'OK' !! 'Error';
