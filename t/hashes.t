my h{};

my g{} = "a": "b", "c": "d";
say g; ## a: b, c: d

say g{"a"}; ## b

my x = g{"a"};
say x; ## b
