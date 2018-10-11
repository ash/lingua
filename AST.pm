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
