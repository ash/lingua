use LinguaAST;

class LinguaFunctions {
    # print and say

    multi method call-function(Str $function-name where 'say' | 'print', %var, $node) {
        say $node.^name;
        print self.gist(%var, $node);
        say '' if $function-name eq 'say';
    }

    multi method gist(%var, AST::Variable $value) {
        return %var{$value.variable-name};
    }

    multi method gist(%var, AST::Variable $value where %var{$value.variable-name} ~~ Array) {
        return %var{$value.variable-name}.join(', '); #'
    }

    multi method gist(%var, AST::ArrayItem $item where %var{$item.variable-name} ~~ Str) {
        return %var{$item.variable-name}.substr($item.index.value, 1);
    }

    multi method gist(%var, AST::ArrayItem $item where %var{$item.variable-name} ~~ Array) {
        return %var{$item.variable-name}[$item.index.value];
    }

    multi method gist(%var, AST::Variable $value where %var{$value.variable-name} ~~ Hash) {
        my $data = %var{$value.variable-name};
        my @str;
        for $data.keys.sort -> $key {
            @str.push("$key: $data{$key}");
        }
        return @str.join(', '); #'
    }

    multi method gist(%var, AST::HashItem $item) {
        return %var{$item.variable-name}{$item.key.value};
    }

    multi method gist(%var, ASTNode $value) {
        return $value.value;
    }

    # len

    multi method call-function('len', %var, ASTNode $node) {
        
    }
}
