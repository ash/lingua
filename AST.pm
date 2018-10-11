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

class AST::Null is ASTNode {
}
