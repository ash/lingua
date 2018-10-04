use Lingua;
use LinguaActions;

my $code = 'test5.lng'.IO.slurp();
my $result = Lingua.parse($code, :actions(LinguaActions));
say $result ?? 'OK' !! 'Error';
