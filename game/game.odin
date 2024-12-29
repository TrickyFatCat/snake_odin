package game

import rl "vendor:raylib"

Vec2i :: [2]i32

VEC_ZERO: Vec2i : {0, 0}
VEC_UP: Vec2i : {0, -1}
VEC_DOWN: Vec2i : {0, 1}
VEC_LEFT: Vec2i : {-1, 0}
VEC_RIGHT: Vec2i : {1, 0}

Grid :: struct {
	size:      Vec2i,
	cell_size: i32,
}

draw_rectangle :: proc(position: Vec2i, size: i32, color: rl.Color) {
	rl.DrawRectangle(position.x * size, position.y * size, size, size, color)
}

calc_canvas_size :: proc(grid: ^Grid) -> (canvas_size: i32) {
	if grid == nil {
		return canvas_size
	}

	canvas_size = grid.size.y * grid.cell_size
	return canvas_size
}

get_grid_centre_pos :: proc(grid: ^Grid) -> (centre_pos: Vec2i) {
	if grid == nil {
		return centre_pos
	}

	centre_pos = grid.size / 2
	return centre_pos
}

calc_snake_dir :: proc(cur_dir: Vec2i) -> Vec2i {
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

is_hitting_wall :: proc(snake: ^Snake, grid: ^Grid) -> bool {
	if snake == nil {
		return true
	}

	next_cell := get_head_pos(snake)

	if next_cell.x < 0 || next_cell.x >= grid.size.x {
		return true
	}

	if next_cell.y < 0 || next_cell.y >= grid.size.y {
		return true
	}

	return false
}

is_hitting_self :: proc(snake: ^Snake) -> bool {
	if snake == nil {
		return true
	}

	head_pos := get_head_pos(snake)

	for i in 1 ..< get_snake_length(snake) {
		if snake.sections[i] == head_pos {
			return true
		}
	}

	return false
}

reset_snake :: proc(snake: ^Snake, length: i32, position: Vec2i, movement_dir: Vec2i = {0, 1}) {
	if snake == nil {
		return
	}

	trim_snake(snake, length)
	snake.movement_dir = movement_dir
	set_snake_position(snake, position)
}

snake_can_eat :: proc(snake: ^Snake, food: ^Food) -> bool {
	if snake == nil && food == nil {
		return false
	}

	return get_head_pos(snake) == food.position
}

draw_grid :: proc(grid: ^Grid) {
	if grid == nil {
		return
	}

	start_pos: Vec2i
	end_pos: Vec2i
	grid_size := grid.size
	cell_size := grid.cell_size
	grid_length := grid_size * cell_size

    // Draw Horizontal Lines
	for x in 0 ..< grid_size.x {
		for y in 0 ..< grid_size.y {
			start_pos.x = x * cell_size
			start_pos.y = y * cell_size
			end_pos.x = start_pos.x + grid_length.x
			end_pos.y = start_pos.y
			rl.DrawLine(start_pos.x, start_pos.y, end_pos.x, end_pos.y, rl.MAGENTA)
		}
	}

    // Draw Vertical Lines
	for y in 0 ..< grid_size.x {
		for x in 0 ..< grid_size.y {
			start_pos.x = x * cell_size
			start_pos.y = y * cell_size
			end_pos.x = start_pos.x
			end_pos.y = start_pos.y + grid_length.y
			rl.DrawLine(start_pos.x, start_pos.y, end_pos.x, end_pos.y, rl.MAGENTA)
		}
	}
}
