package main

import "core:fmt"
import "core:math"

typeof_int :: proc(i: int) -> string {
    return "int"
}

typeof_f32 :: proc(i: f32) -> string {
    return "f32"
}

typeof_f64 :: proc(i: f64) -> string {
    return "f64"
}

typeof :: proc {
    typeof_int,
    typeof_f32,
    typeof_f64
}

main :: proc() {
    a := 2
    b := 3
    c := 2.0
    d := 3.0
    fmt.printf("a = {} ({})\n", a, typeof(a))
    fmt.printf("b = {} ({})\n", b, typeof(b))
    fmt.printf("c = {} ({})\n", c, typeof(c))
    fmt.printf("d = {} ({})\n", d, typeof(d))
    fmt.printf("a + b = {}\n", a + b)
    fmt.printf("a - b = {}\n", a - b)
    fmt.printf("a * b = {}\n", a * b)
    fmt.printf("a / b = {}\n", a / b)
    fmt.printf("c / d = {}\n", c / d)
    fmt.printf("f32(a) / f32(b) = {}\n", f32(a) / f32(b))
    fmt.printf("\n")
    fmt.printf("sin(c) = {}\n", math.sin(c))
    fmt.printf("typeof sin(c) = {}\n", typeof(math.sin(c)))
    fmt.printf("sin_f32(f32(c)) = {}\n", math.sin_f32(f32(c)))
    fmt.printf("typeof sin_f32(f32(c)) = {}\n", typeof(math.sin_f32(f32(c))))
}
