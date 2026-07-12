use LinguaAST;

class LinguaOptimizer {
    sub is-number($node, $n) {
        return $node ~~ AST::NumberValue && $node.value == $n;
    }

    method optimize(AST::TOP $top) {
        return AST::TOP.new(
            statements => self.optimize-list($top.statements),
        );
    }

    method optimize-list(@statements) {
        my @result;
        for @statements -> $statement {
            my $node = self.optimize-node($statement);

            if $node ~~ AST::Condition && $node.value ~~ AST::NumberValue {
                my @branch = $node.value.value
                    ?? $node.statements
                    !! $node.antistatements;
                @result.append(@branch.grep({ $_ !~~ AST::Null }));
            }
            else {
                @result.push($node);
            }
        }
        return @result;
    }

    # Nodes with child values

    multi method optimize-node(AST::ScalarDeclaration $node) {
        return AST::ScalarDeclaration.new(
            variable-name => $node.variable-name,
            value => self.optimize-node($node.value),
        );
    }

    multi method optimize-node(AST::ScalarAssignment $node) {
        return AST::ScalarAssignment.new(
            variable-name => $node.variable-name,
            rhs => self.optimize-node($node.rhs),
        );
    }

    multi method optimize-node(AST::FunctionCall $node) {
        return AST::FunctionCall.new(
            function-name => $node.function-name,
            argument => self.optimize-node($node.argument),
            evaluator => $node.evaluator,
        );
    }

    multi method optimize-node(AST::UserFunctionCall $node) {
        return AST::UserFunctionCall.new(
            function-name => $node.function-name,
            arguments => ($node.arguments.map: { self.optimize-node($_) }),
            evaluator => $node.evaluator,
        );
    }

    multi method optimize-node(AST::Return $node) {
        return AST::Return.new(
            value => self.optimize-node($node.value),
        );
    }

    multi method optimize-node(AST::MathOperations $node) {
        my @operands = $node.operands.map: { self.optimize-node($_) };

        my $new = AST::MathOperations.new(
            operators => $node.operators,
            operands => @operands,
        );

        if all(@operands) ~~ AST::NumberValue {
            return AST::NumberValue.new(value => $new.value);
        }

        if @operands.elems == 2 {
            my ($a, $b) = @operands;
            my $op = $node.operators[0];

            return $a if $op eq '+' && is-number($b, 0);
            return $b if $op eq '+' && is-number($a, 0);
            return $a if $op eq '-' && is-number($b, 0);
            return $a if $op eq '*' && is-number($b, 1);
            return $b if $op eq '*' && is-number($a, 1);
            return $a if $op eq '/' && is-number($b, 1);

            return AST::NumberValue.new(value => 0)
                if $op eq '*' && (is-number($a, 0) || is-number($b, 0));
        }

        return $new;
    }

    # Nodes with statement lists

    multi method optimize-node(AST::Condition $node) {
        return AST::Condition.new(
            value => self.optimize-node($node.value),
            statements => self.optimize-list($node.statements),
            antistatements => self.optimize-list($node.antistatements),
        );
    }

    multi method optimize-node(AST::Loop $node) {
        return AST::Loop.new(
            variable => $node.variable,
            statements => self.optimize-list($node.statements),
        );
    }

    multi method optimize-node(AST::While $node) {
        return AST::While.new(
            value => self.optimize-node($node.value),
            statements => self.optimize-list($node.statements),
        );
    }

    multi method optimize-node(AST::FunctionDefinition $node) {
        return AST::FunctionDefinition.new(
            function-name => $node.function-name,
            parameters => $node.parameters,
            statements => self.optimize-list($node.statements),
        );
    }

    # Everything else stays as is

    multi method optimize-node(ASTNode $node) {
        return $node;
    }
}
