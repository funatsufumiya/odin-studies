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

	pass_action.colors[0] = { load_action = .CLEAR, clear_value = { 1.0, 0.0, 0.0, 1.0 } }
	
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

	g := pass_action.colors[0].clear_value.g + 0.01
    pass_action.colors[0].clear_value.g = g > 1.0 ? 0.0 : g

	sg.begin_pass({ action = pass_action, swapchain = sglue.swapchain() })
	sg.end_pass()
	sg.commit()
}