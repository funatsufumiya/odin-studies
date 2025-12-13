package main

import "core:fmt"
import "base:runtime"
import sapp "shared:sokol/app"
import sg "shared:sokol/gfx"
import sgl "shared:sokol/gl"
import sglue "shared:sokol/glue"
import slog "shared:sokol/log"

pass_action: sg.Pass_Action

main :: proc() {
	sapp.run({
		width =             640,
		height =            480,
		init_userdata_cb =  init,
		frame_userdata_cb = frame,
		cleanup_cb =        cleanup,
		window_title =      "Sokol Drawing Template",
	})
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sg.shutdown()
}

init :: proc "c" (user_data: rawptr) {
	context = runtime.default_context()

	sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

	pass_action.colors[0] = { load_action = .CLEAR, clear_value = { 0.0, 0.0, 0.0, 1.0 } }
	
	sgl.setup({
        logger = { func = slog.func },
    })

	// just some debug output what backend we're running on
    switch sg.query_backend() {
    case .D3D11: fmt.println(">> using D3D11 backend")
    case .GLCORE, .GLES3: fmt.println(">> using GL backend")
    case .METAL_MACOS, .METAL_IOS, .METAL_SIMULATOR: fmt.println(">> using Metal backend")
    case .WGPU: fmt.println(">> using WebGPU backend")
    case .VULKAN: fmt.println(">> using Vulkan backend")
    case .DUMMY: fmt.println(">> using dummy backend")
    }
}

frame :: proc "c" (user_data: rawptr) {
	context = runtime.default_context()

	// compute viewport rectangles so that the views are horizontally
    // centered and keep a 1:1 aspect ratio
    dw := sapp.width()
    dh := sapp.height()
    ww := dh / 2 // not a bug
    hh := dh / 2
    x0 := dw / 2 - hh
    x1 := dw / 2
    y0 := 0
    y1 := dh / 2

	sgl.viewport(x0, y0, ww, hh, true)

	// g := pass_action.colors[0].clear_value.g + 0.01
    // pass_action.colors[0].clear_value.g = g > 1.0 ? 0.0 : g

	draw()

	sg.begin_pass({ action = pass_action, swapchain = sglue.swapchain() })
	sgl.draw()
	sg.end_pass()
	sg.commit()
}

draw :: proc "c" () {
	context = runtime.default_context()

	// first, reset and setup ortho projection
	sgl.defaults()
	sgl.matrix_mode_projection()
	sgl.ortho(0.0, f32(sapp.width()), f32(sapp.height()), 0.0, -1.0, 1.0)
	sgl.c4b(255, 0, 0, 128)
	draw_hollow_rect(220, 140, 200, 200)
	sgl.c4b(25, 150, 255, 128)
	draw_filled_rect(270, 190, 100, 100)
	// line(0, 0, 500, 500)
}

draw_hollow_rect :: proc(x: f32, y: f32, w: f32, h: f32) {
	sgl.begin_line_strip()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.v2f(x, y)
	sgl.end()
}

draw_filled_rect :: proc(x: f32, y: f32, w: f32, h: f32) {
	sgl.begin_quads()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.end()
}
