package main

import "core:fmt"

my_global: int = 3

A :: struct {
    x: ^int,
    fn: proc(self: ^A) -> int
}

main :: proc() {
    x : int = 7
    a := A {
        &x, 
        proc(self: ^A) -> int {
            return self.x^
        }
    }

    fmt.printf("hello {}\n", a.fn(&a))
}
