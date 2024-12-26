package game

import rl "vendor:raylib"

Vec2i :: [2]i32

VEC_UP    : Vec2i : {0, -1}
VEC_DOWN  : Vec2i : {0, 1}
VEC_LEFT  : Vec2i : {-1, 0}
VEC_RIGHT : Vec2i : {1, 0}

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

calc_snake_dir :: proc(cur_dir: Vec2i) -> Vec2i{
    if rl.IsKeyDown(.UP) && cur_dir != VEC_DOWN {
        return VEC_UP
    }

    if rl.IsKeyDown(.DOWN) && cur_dir != VEC_UP {
        return VEC_DOWN
    }

    if rl.IsKeyDown(.LEFT) && cur_dir != VEC_RIGHT {
        return VEC_LEFT
    }

    if rl.IsKeyDown(.RIGHT) && cur_dir != VEC_LEFT {
        return VEC_RIGHT
    }

    return cur_dir
}