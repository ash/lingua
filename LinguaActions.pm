use LinguaAST;
use LinguaEvaluator;

class LinguaActions {
    has LinguaEvaluator $.evaluator;

    method TOP($/) {
        my $top = AST::TOP.new;
        for $<statement> -> $statement {
            $top.statements.push($statement.made);
        }

        $/.make($top);
    }

    multi method statement($/ where !$<condition>) {
        $/.make($<statement>.made);
    }

    multi method statement($/ where $<condition>) {
        $/.make(AST::Condition.new(
            value => $/<condition><value>.made,
            statement => $/<statement>.made,
        ));
    }

    multi method variable-declaration($/) {
        $/.make($<declaration>.made);
    }

    method scalar-declaration($/) {
        $/.make(AST::ScalarDeclaration.new(
            variable-name => ~$<variable-name>,
            value => $<value> ?? $<value>.made !! AST::Null.new(),
        ));
    }

    multi method array-declaration($/ where !$<value>) {
        $/.make(AST::ArrayDeclaration.new(
            variable-name => ~$<variable-name>,
            elements => []
        ));
    }

    sub init-array($variable-name, $elements) {
        return AST::ArrayAssignment.new(
            variable-name => $variable-name,
            elements => $elements.map: *.made
        );
    }

    multi method array-declaration($/ where $<value>) {
        $/.make(init-array(~$<variable-name>, $<value>));
    }

    multi method hash-declaration($/ where !$<string>) {
        $/.make(AST::HashDeclaration.new(
            variable-name => ~$<variable-name>,
            elements => {}
        ));
    }

    sub init-hash($variable-name, $keys, $values) {
        return AST::HashAssignment.new(
            variable-name => $variable-name,
            keys => ($keys.map: *.made.value),
            values => ($values.map: *.made)
        );
    }

    multi method hash-declaration($/ where $<string> && $<value>) {
        $/.make(init-hash(~$<variable-name>, $<string>, $<value>));
    }

    multi method assignment($/ where $<index> && $<index><array-index>) {
        $/.make(AST::ArrayItemAssignment.new(
            variable-name => ~$<variable-name>,
            index => $<index>.made.value,
            rhs => $<value>[0].made
        ));
    }

    multi method assignment($/ where $<index> && $<index><hash-index>) {
        $/.make(AST::HashItemAssignment.new(
            variable-name => ~$<variable-name>,
            key => $<index>.made.value,
            rhs => $<value>[0].made
        ));
    }

    multi method assignment($/ where !$<index> && $<value> && !$<string>) {
        if $<value>.elems == 1 {
            $/.make(AST::ScalarAssignment.new(
                variable-name => ~$<variable-name>,
                rhs => $<value>[0].made
            ));
        }
        else {
            $/.make(AST::ArrayAssignment.new(
                variable-name => ~$<variable-name>,
                elements => ($<value>.map: *.made)
            ));
        }
    }

    multi method assignment($/ where !$<index> && $<value> && $<string>) {
        $/.make(init-hash(~$<variable-name>, $<string>, $<value>));
    }

    multi method index($/ where $<array-index>) {
        $/.make($<array-index>.made);
    }

    multi method index($/ where $<hash-index>) {
        $/.make($<hash-index>.made);
    }

    multi method array-index($/ where !$<variable-name>) {
        $/.make(AST::NumberValue.new(
            value => +$<integer>
        ));
    }

    multi method array-index($/ where $<variable-name>) {
        $/.make(AST::Variable.new(
            variable-name => ~$<variable-name>,
            evaluator => $!evaluator,
        ));
    }

    multi method hash-index($/ where !$<variable-name>) {
        $/.make($<string>.made);
    }

    multi method hash-index($/ where $<variable-name>) {
        $/.make(AST::Variable.new(
            variable-name => ~$<variable-name>,
            evaluator => $!evaluator,
        ));
    }

    method function-call($/) {
        $/.make(AST::FunctionCall.new(
            function-name => ~$<function-name>,
            value => $<value>.made
        ));
    }

    multi method value($/ where $<variable-name> && !$<index>) {
        $/.make(AST::Variable.new(
            variable-name => ~$<variable-name>,
            evaluator => $!evaluator,
        ));
    }

    multi method value($/ where $<variable-name> && $<index> && $<index><array-index>) {
        $/.make(AST::ArrayItem.new(
            variable-name => ~$<variable-name>,
            index => $<index>.made,
            evaluator => $!evaluator,
        ));
    }

    multi method value($/ where $<variable-name> && $<index> && $<index><hash-index>) {
        $/.make(AST::HashItem.new(
            variable-name => ~$<variable-name>,
            key => $<index>.made,
            evaluator => $!evaluator,
        ));
    }

    multi method value($/ where $<expression>) {
        $/.make($<expression>.made);
    }

    multi method value($/ where $<string>) {
        $/.make($<string>.made);
    }

    method expression($/) {
        $/.make($<expr>.made);
    }

    multi method expr($/ where $<number>) {
        $/.make($<number>.made);
    }

    multi method expr($/ where $<string>) {
        $/.make($<string>.made);
    }

    multi method expr($/ where $<variable-name> && !$<index>) {
        $/.make(AST::Variable.new(
            variable-name => ~$<variable-name>,
            evaluator => $!evaluator,
        ));
    }

    multi method expr($/ where $<variable-name> && $<index> && $<index><array-index>) {
        $/.make(AST::ArrayItem.new(
            variable-name => ~$<variable-name>,
            index => $<index>.made,
            evaluator => $!evaluator,
        ));
    }

    multi method expr($/ where $<variable-name> && $<index> && $<index><hash-index>) {
        $/.make(AST::HashItem.new(
            variable-name => ~$<variable-name>,
            key => $<index>.made.value,
            evaluator => $!evaluator,
        ));
    }

    multi method expr($/ where $<expr> && !$<op>) {
        $/.make($<expr>[0].made);
    }

    multi method expr($/ where $<expr> && $<op>) {
        $/.make(AST::MathOperations.new(
            operators => ($<op>.map: ~*),
            operands => ($<expr>.map: *.made)
        ));
    }

    multi method expr($/ where $<expression>) {
        $/.make($<expression>.made);
    }

    method number($/) {
        $/.make(AST::NumberValue.new(
            value => +$/
        ));
    }

    method string($/) {
        my $match = $/[0];

        my @interpolations;
        push @interpolations, [
                .Str,
                .from - $match.from - 1,
                .pos - .from + 1,
            ] for $match<variable-name>;

        $/.make(AST::StringValue.new(
            evaluator => $!evaluator,
            value => ~$match,
            interpolations => @interpolations
        ));
    }
}
