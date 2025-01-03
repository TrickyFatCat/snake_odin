package game

import rl "vendor:raylib"

Food :: struct {
	position: Vec2i,
	sprite:   rl.Texture2D,
}

create_food :: proc(position: Vec2i, sprite: cstring) -> (new_food: ^Food) {
	new_food = new(Food, context.allocator)
	new_food.position = position

	if len(sprite) > 0 {
		new_food.sprite = rl.LoadTexture(sprite)
	}

	return new_food
}

remove_food :: proc(food: ^Food) -> bool {
	if food == nil {
		return false
	}

	rl.UnloadTexture(food.sprite)
	free(food, context.allocator)
	return true
}

draw_food :: proc(food: ^Food, sprite_size: i32) {
	if food == nil {
		return
	}

	if &food.sprite == nil {
		draw_rectangle(food.position, sprite_size, rl.MAGENTA)
	} else {
		rl.DrawTextureV(
			food.sprite,
			{f32(food.position.x), f32(food.position.y)} * f32(sprite_size),
			rl.WHITE,
		)

		if ODIN_DEBUG {
			rl.DrawRectangleLines(
				food.position.x * sprite_size,
				food.position.y * sprite_size,
				sprite_size,
				sprite_size,
				rl.RED,
			)
		}
	}
}

place_food :: proc(food: ^Food, grid: ^Grid, snake: ^Snake) {
	if food == nil || grid == nil || snake == nil {
		return
	}

	food.position = calc_food_position(grid, snake)
}

calc_food_position :: proc(grid: ^Grid, snake: ^Snake) -> (new_position: Vec2i) {
	if grid == nil || snake == nil {
		return new_position
	}

	free_cells := make([dynamic]Vec2i, context.temp_allocator)
	position: Vec2i

	for x in 0 ..< grid.size.x {
		for y in 0 ..< grid.size.y {
			position = {x, y}

			if !is_position_ocuupied(position, &snake.sections) {
				append(&free_cells, Vec2i{x, y})
			}
		}
	}

	cells_num: i32 = i32(len(free_cells))

	if cells_num > 0 {
		random_cell_index := rl.GetRandomValue(0, cells_num - 1)
		new_position = free_cells[random_cell_index]
	}

	delete(free_cells)

	return new_position
}

is_position_ocuupied :: proc(target_pos: Vec2i, pos_array: ^[dynamic]Vec2i) -> bool {
	if len(pos_array) == 0 {
		return false
	}

	for pos in pos_array {
		if pos == target_pos {
			return true
		}
	}

	return false
}
