package main

import "core:fmt"

my_global: int = 3

main :: proc() {
    fn := proc() -> int {
        return my_global
    }

    fmt.printf("hello {}\n", fn())
}
