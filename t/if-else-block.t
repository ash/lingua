my c = 0;
if c {
    say "Not printed";
}
else {
    say "c = $c";
    say "ELSE block";
}

## c = 0
## ELSE block

c = 1;
if c {
    say "c = $c";   
    say "IF block"; 
}
else {
    say "Not printed either";
}

## c = 1
## IF block
