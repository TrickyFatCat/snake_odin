package game

import rl "vendor:raylib"

Snake :: struct {
    length: i32,
    movement_dir : Vec2i,
    sections : [dynamic]Vec2i
}

create_snake :: proc (position: Vec2i, length: i32, dir: Vec2i) -> (new_snake : ^Snake) {
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