#!/usr/bin/env /Applications/Rakudo/bin/perl6

use Lingua;
use LinguaActions;

error('Usage: ./lingua <filename>') unless @*ARGS.elems;

my $filename = @*ARGS[0];
error("Error: File $filename not found") unless $filename.IO.f;

my $code = $filename.IO.slurp();
my $result = Lingua.parse($code, :actions(LinguaActions));
say $result ?? 'OK' !! error('Error: parse failed');

sub error($message) {
    note $message;
    exit;
}