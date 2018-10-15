use LinguaAST;

class LinguaEvaluator {
    has %!var;

    method eval(ASTNode $top) {
        dd $top;

        self.eval-node($_) for $top.statements;

        dd %!var;
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

    # Functions

    multi method eval-node(AST::FunctionCall $node) {
        self.call-function($node.function-name, $node.value);
    }

    multi method call-function('say', AST::Variable $value) {
        say %!var{$value.variable-name};
    }

    multi method call-function('say', AST::NumberValue $value) {
        say $value.value;
    }

    multi method call-function('say', AST::StringValue $value) {
        say $value.value;
    }
}
