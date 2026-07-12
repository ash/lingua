use LinguaAST;
use LinguaFunctions;

class X::LinguaReturn is Exception {
    has $.value;
}

class LinguaEvaluator {
    has %.var;
    has %!func;

    method eval(ASTNode $top) {
        self.eval-node($_) for $top.statements;
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

    multi method eval-node(AST::FunctionDefinition $node) {
        %!func{$node.function-name} = $node;
    }

    multi method eval-node(AST::UserFunctionCall $node) {
        $node.value;
    }

    multi method eval-node(AST::Return $node) {
        X::LinguaReturn.new(value => $node.value.value).throw;
    }

    method call-user-function($function-name, @arguments) {
        die "Unknown function $function-name"
            unless %!func{$function-name}:exists;

        my $function = %!func{$function-name};
        my @values = @arguments.map: *.value;

        my %saved-vars = %!var;
        %!var = ();
        for ^$function.parameters.elems -> $i {
            %!var{$function.parameters[$i]} = @values[$i];
        }

        my $result = 0;
        {
            self.eval-node($_) for $function.statements;

            CATCH {
                when X::LinguaReturn {
                    $result = .value;
                }
            }
        }

        %!var = %saved-vars;

        return $result;
    }

    method call-function($function-name, $argument) {
        return LinguaFunctions.call-function($function-name, %!var, $argument);
    }

    multi method eval-node(AST::FunctionCall $node) {
        self.call-function($node.function-name, $node.argument);
    }
}
