class ASTNode {
}

class AST::TOP is ASTNode {
    has ASTNode @.statements;
}

class AST::ScalarDeclaration is ASTNode {
    has Str $.variable-name;    
    has ASTNode $.value;
}

class AST::NumberValue is ASTNode {
    has $.value;
}

class AST::StringValue is ASTNode {
    has Str $.value;
    has @.interpolations;
    has $.evaluator;

    method value() {
        my $s = $!value;

        for @!interpolations.reverse -> $var {
            $s.substr-rw($var[1], $var[2]) = $.evaluator.var{$var[0]};
        }

        $s ~~ s:g/\\\"/"/;
        $s ~~ s:g/\\\\/\\/;
        $s ~~ s:g/\\\$/\$/;

        return $s;
    }
}

class AST::Null is ASTNode {
}

class AST::Variable is ASTNode {
    has Str $.variable-name;
}

class AST::ArrayDeclaration is ASTNode {
    has Str $.variable-name;
    has ASTNode @.elements;
}

class AST::HashDeclaration is ASTNode {
    has Str $.variable-name;
    has ASTNode %.elements;
}

class AST::ScalarAssignment is ASTNode {
    has Str $.variable-name;
    has ASTNode $.rhs;
}

class AST::ArrayItemAssignment is ASTNode {
    has Str $.variable-name;
    has Int $.index;
    has ASTNode $.rhs;
}

class AST::HashItemAssignment is ASTNode {
    has Str $.variable-name;
    has Str $.key;
    has ASTNode $.rhs;
}

class AST::ArrayAssignment is ASTNode {
    has Str $.variable-name;
    has ASTNode @.elements;
}

class AST::HashAssignment is ASTNode {
    has Str $.variable-name;
    has Str @.keys;
    has ASTNode @.values;
}

class AST::MathOperations is ASTNode {
    has Str @.operators;
    has ASTNode @.operands;
}

class AST::ArrayItem is ASTNode {
    has Str $.variable-name;
    has ASTNode $.index;
}

class AST::HashItem is ASTNode {
    has Str $.variable-name;
    has ASTNode $.key;
}

class AST::FunctionCall is ASTNode {
    has Str $.function-name;
    has ASTNode $.value;
}
