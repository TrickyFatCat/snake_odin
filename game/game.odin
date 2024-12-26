package game

import rl "vendor:raylib"

Vec2i :: [2]i32

Grid :: struct {
    size: Vec2i,
    cell_size: i32
}

draw_sprite :: proc(position: Vec2i, size: i32, color: rl.Color) {
    rl.DrawRectangle(position.x * size, position.y * size, size, size, color)
}

calc_canvas_size :: proc(grid: ^Grid) -> (canvas_size : i32) {
    if grid == nil {
        return canvas_size
    }
    
    canvas_size = grid.size.y * grid.cell_size
    return canvas_size
}

get_grid_centre_pos :: proc(grid: ^Grid) -> (centre_pos : Vec2i) {
    if grid == nil {
        return centre_pos
    }

    centre_pos = grid.size / 2
    return centre_pos
}