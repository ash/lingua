my $print-instructions = 'say' | 'print';

for < say print put > -> $function-name {    
    say $function-name eq $print-instructions
        ?? "✓ $function-name" !! "✗ $function-name";
}
