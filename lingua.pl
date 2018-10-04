use Lingua;
use LinguaActions;

my $code = 'test6.lng'.IO.slurp();
my $result = Lingua.parse($code, :actions(LinguaActions));
say $result ?? 'OK' !! 'Error';
