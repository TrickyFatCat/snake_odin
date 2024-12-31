package game

import "core:math"
import rl "vendor:raylib"

Snake :: struct {
	movement_dir: Vec2i,
	sprites:      [3]rl.Texture2D,
	sections:     [dynamic]Vec2i,
}

create_snake :: proc(
	position: Vec2i = VEC_ZERO,
	length: i32 = 3,
	dir: Vec2i = VEC_DOWN,
	sprites: [3]cstring,
) -> (
	new_snake: ^Snake,
) {
	if length <= 0 {
		return new_snake
	}

	new_snake = new(Snake, context.allocator)
	new_snake.sections = make([dynamic]Vec2i, length)
	new_snake.sections[0] = position

	for i in 1 ..< length {
		new_snake.sections[i] = new_snake.sections[0] - dir * {0, i}
	}

	new_snake.movement_dir = dir

	address: cstring

	for i in 0 ..< len(sprites) {
		address = sprites[i]

		if len(address) < 0 {
			continue
		}

		new_snake.sprites[i] = rl.LoadTexture(address)
	}
	return new_snake
}

remove_snake :: proc(snake: ^Snake) -> bool {
	if snake == nil {
		return false
	}

	for sprite in snake.sprites {
		rl.UnloadTexture(sprite)
	}

	delete(snake.sections)
	free(snake, context.allocator)
	return true
}

get_head_pos :: proc(snake: ^Snake) -> Vec2i {
	if snake == nil {
		return {-1, -1}
	}

	if len(snake.sections) == 0 {
		return {-1, -1}
	}

	return snake.sections[0]
}

move_snake :: proc(snake: ^Snake) {
	if snake == nil {
		return
	}

	cur_pos := snake.sections[0]
	next_pos := cur_pos
	snake.sections[0] += snake.movement_dir

	for i in 1 ..< len(&snake.sections) {
		cur_pos = snake.sections[i]
		snake.sections[i] = next_pos
		next_pos = cur_pos
	}
}

change_snake_movement_dir :: proc(snake: ^Snake, new_dir: Vec2i) {
	if snake == nil {
		return
	}

	snake.movement_dir = new_dir
}

draw_snake :: proc(snake: ^Snake, sprite_size: i32) {
	if snake == nil {
		return
	}

	last_index := len(&snake.sections) - 1
	sprite: ^rl.Texture2D
	section: Vec2i
	sprite_pos: rl.Vector2
	rot_deg: f32
	dir: Vec2i
	source_rec: rl.Rectangle
	dest_rec: rl.Rectangle
	sprite_half_size := f32(sprite_size) * 0.5
	origin: rl.Vector2 = {sprite_half_size, sprite_half_size}


	for i in 0 ..= last_index {
		section = snake.sections[i]

		switch i {
		case 0:
			sprite = &snake.sprites[0]
			dir = section - snake.sections[i + 1]
		case last_index:
			sprite = &snake.sprites[2]
			dir = snake.sections[i - 1] - section
		case:
			sprite = &snake.sprites[1]
			dir = snake.sections[i - 1] - section
		}

		if sprite == nil {
			draw_rectangle(section, sprite_size, rl.MAGENTA)
			continue
		}

		rot_deg = math.atan2(f32(dir.y), f32(dir.x)) * math.DEG_PER_RAD
		sprite_pos = {f32(section.x), f32(section.y)} * f32(sprite_size) + sprite_half_size

		source_rec = {
			width  = f32(sprite.width),
			height = f32(sprite.height),
		}

		dest_rec = {
			x      = sprite_pos.x,
			y      = sprite_pos.y,
			width  = f32(sprite_size),
			height = f32(sprite_size),
		}

		rl.DrawTexturePro(sprite^, source_rec, dest_rec, origin, rot_deg, rl.WHITE)

		// Draw debug boxes to see actual snake sections
		if ODIN_DEBUG {
			rl.DrawRectangleLines(
				section.x * sprite_size,
				section.y * sprite_size,
				sprite_size,
				sprite_size,
				rl.GREEN,
			)
		}
	}
}

get_snake_length :: proc(snake: ^Snake) -> i32 {
	if snake == nil {
		return -1
	}

	return i32(len(snake.sections))
}

trim_snake :: proc(snake: ^Snake, new_length: i32 = 3) {
	if snake == nil || new_length <= 0 {
		return
	}

	snake_length := get_snake_length(snake)

	if (new_length >= snake_length) {
		return
	}

	for i in 0 ..< (snake_length - new_length) {
		pop(&snake.sections)
	}
}

set_snake_position :: proc(snake: ^Snake, new_pos: Vec2i) {
	if snake == nil {
		return
	}

	snake.sections[0] = new_pos

	for i in 1 ..< get_snake_length(snake) {
		snake.sections[i] = snake.sections[0] - snake.movement_dir * {0, i}
	}
}

incrment_snake :: proc(snake: ^Snake) {
	if snake == nil {
		return
	}

	cur_length := get_snake_length(snake) - 1
	new_section_pos := snake.sections[cur_length] - {0, 1} * snake.movement_dir
	append(&snake.sections, new_section_pos)
}
