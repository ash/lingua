class Variable {
}

class NumVar is Variable {
    has Rat $.value;
}

class StrVar is Variable {
    has Str $.value;
}
