package game

import rl "vendor:raylib"

Snake :: struct {
    movement_dir : Vec2i,
    sections : [dynamic]Vec2i
}

create_snake :: proc (position: Vec2i = {0, 0}, length: i32 = 3, dir: Vec2i = {0, 1}) -> (new_snake : ^Snake) {
    if length <= 0 {
        return new_snake
    }

    new_snake = new(Snake,context.allocator)
    new_snake.sections = make([dynamic]Vec2i, length)
    new_snake.sections[0] = position

    for i in 1..<length {
        new_snake.sections[i] = new_snake.sections[0] - dir * {0, i}
    }

    new_snake.movement_dir = dir
    return new_snake
}

remove_snake :: proc (snake: ^Snake) -> bool {
    if snake == nil {
        return false
    }

    delete(snake.sections)
    free(snake, context.allocator)
    return true
}

get_head_pos :: proc(snake: ^Snake) -> Vec2i {
    if snake == nil{
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

    for i in 1..<len(&snake.sections) {
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

    for i in 0..<len(&snake.sections) {
        color := rl.YELLOW if i == 0 else rl.GREEN
        draw_sprite(snake.sections[i], sprite_size, color)
    }
}

get_snake_length :: proc (snake: ^Snake) -> i32 { 
    if snake == nil {
        return -1
    }

    return i32(len(snake.sections))
}

trim_snake :: proc(snake: ^Snake, new_length: i32 = 3) {
    if snake == nil || new_length <= 0{
        return
    }

    snake_length := get_snake_length(snake)

    if (new_length >= snake_length) {
        return
    }

    for i in 0..<(snake_length - new_length) {
        pop(&snake.sections)
    }
}

set_snake_position :: proc(snake: ^Snake, new_pos: Vec2i) {
    if snake == nil {
        return
    }

    snake.sections[0] = new_pos

    for i in 1..<get_snake_length(snake) {
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