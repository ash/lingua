func add(a, b) {
    return a + b;
}
say add(3, 4); ## 7
my s = add(10, add(1, 2));
say s; ## 13
say add(1, 1) * add(2, 2); ## 8
func greeting(name) {
    return "Hello, $name!";
}
say greeting("World"); ## Hello, World!
