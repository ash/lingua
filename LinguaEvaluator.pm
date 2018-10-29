use LinguaAST;

class LinguaEvaluator {
    has %.var;

    method eval(ASTNode $top) {
        dd $top;

        self.eval-node($_) for $top.statements;

        dd %!var;
    }

    # Control flow

    multi method eval-node(AST::Condition $node) {
        if $node.value.value {
            self.eval-node($_) for $node.statements;
        }
        else {
            self.eval-node($_) for $node.antistatements;
        }
    }

    multi method eval-node(AST::Loop $node) {
        while %!var{$node.variable.variable-name} > 0 {
            self.eval-node($_) for $node.statements;
            %!var{$node.variable.variable-name}--;
        }
    }

    multi method eval-node(AST::While $node) {
        while $node.value.value {
            self.eval-node($_) for $node.statements;            
        }
    }

    multi method eval-node(AST::Null) {
    }

    # Variables

    multi method eval-node(AST::ScalarDeclaration $node) {
        %!var{$node.variable-name} =
            $node.value ~~ AST::Null ?? 0 !! $node.value.value;
    }

    multi method eval-node(AST::ScalarAssignment $node) {
        %!var{$node.variable-name} = $node.rhs.value;
    }

    multi method eval-node(AST::ArrayDeclaration $node) {
        %!var{$node.variable-name} = Array.new;
    }

    multi method eval-node(AST::HashDeclaration $node) {
        %!var{$node.variable-name} = Hash.new;
    }

    multi method eval-node(AST::ArrayItemAssignment $node) {
        %!var{$node.variable-name}[$node.index] = $node.rhs.value;
    }

    multi method eval-node(AST::HashItemAssignment $node) {
        %!var{$node.variable-name}{$node.key} = $node.rhs.value;
    }

    multi method eval-node(AST::ArrayAssignment $node) {
        %!var{$node.variable-name} = ($node.elements.map: *.value).Array;
    }

    multi method eval-node(AST::HashAssignment $node) {
        %!var{$node.variable-name} = Hash.new;
        for 0 .. $node.keys.elems - 1 -> $i {
            %!var{$node.variable-name}.{$node.keys[$i]} = $node.values[$i].value;
        }
    }

    # Functions

    multi method eval-node(AST::FunctionCall $node) {
        self.call-function($node.function-name, $node.value);
    }

    multi method call-function('say', AST::Variable $value) {
        say %!var{$value.variable-name};
    }

    multi method call-function('say', AST::Variable $value where %!var{$value.variable-name} ~~ Array) {
        say %!var{$value.variable-name}.join(', ');
    }

    multi method call-function('say', AST::ArrayItem $item where %!var{$item.variable-name} ~~ Str) {
        say %!var{$item.variable-name}.substr($item.index.value, 1);
    }

    multi method call-function('say', AST::ArrayItem $item where %!var{$item.variable-name} ~~ Array) {
        say %!var{$item.variable-name}[$item.index.value];
    }

    multi method call-function('say', AST::Variable $value where %!var{$value.variable-name} ~~ Hash) {
        my $data = %!var{$value.variable-name};
        my @str;
        for $data.keys.sort -> $key {
            @str.push("$key: $data{$key}");
        }
        say @str.join(', ');
    }

    multi method call-function('say', AST::HashItem $item) {
        say %!var{$item.variable-name}{$item.key.value};
    }

    multi method call-function('say', ASTNode $value) {
        say $value.value;
    }
}
