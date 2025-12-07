package main

import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c"
import "base:runtime"

state: ^lua.State

lua_allocator :: proc "c" (ud: rawptr, ptr: rawptr, osize, nsize: c.size_t) -> (buf: rawptr) {
	old_size := int(osize)
	new_size := int(nsize)
	context = (^runtime.Context)(ud)^

	if ptr == nil {
		data, err := runtime.mem_alloc(new_size)
		return raw_data(data) if err == .None else nil
	} else {
		if nsize > 0 {
			data, err := runtime.mem_resize(ptr, old_size, new_size)
			return raw_data(data) if err == .None else nil
		} else {
			runtime.mem_free(ptr)
			return
		}
	}
}

main :: proc() {
	_context := context
	state = lua.newstate(lua_allocator, &_context)
	defer lua.close(state)

	lua.L_dostring(state, "return 'hello from lua on odin!'")
	str := lua.tostring(state, -1)
	fmt.println(str)
}