package main

import "core:fmt"

my_global: int = 3

A :: struct {
    x: ^int,
    fn: proc() -> int
}

self : ^A // workaround as self pointer

main :: proc() {
    x : int = 7
    a := A {
        &x, 
        proc() -> int {
            return self.x^
        }
    }

    self = &a

    fmt.printf("hello {}\n", a.fn())
}
