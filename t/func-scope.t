my x = 100;
func double(a) {
    my x = a * 2;
    return x;
}
say double(3); ## 6
say x; ## 100
x = double(x);
say x; ## 200
