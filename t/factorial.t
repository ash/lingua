func fact(n) {
    if n <= 1 {
        return 1;
    }
    return n * fact(n - 1);
}
say fact(1); ## 1
say fact(5); ## 120
say fact(10); ## 3628800
func fib(n) {
    if n <= 2 {
        return 1;
    }
    return fib(n - 1) + fib(n - 2);
}
say fib(10); ## 55
