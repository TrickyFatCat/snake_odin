package game

import rl "vendor:raylib"

Snake :: struct {
    length: i32,
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

    new_snake.length = length
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

    for i in 1..<snake.length {
        cur_pos = snake.sections[i]
        snake.sections[i] = next_pos
        next_pos = cur_pos
    }
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