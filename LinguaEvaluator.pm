use LinguaAST;

class LinguaEvaluator {
    has %!var;

    method eval(ASTNode $top) {
        dd $top;

        self.eval-node($_) for $top.statements;

        dd %!var;
    }

    multi method eval-node(AST::ScalarDeclaration $node) {
        %!var{$node.variable-name} =
            $node.value ~~ AST::Null ?? 0 !! $node.value.value;
    }

    multi method eval-node(AST::FunctionCall $node) {
        self.call-function($node.function-name, $node.value);
    }

    multi method call-function('say', AST::Variable $value) {
        say %!var{$value.variable-name};
    }
}
