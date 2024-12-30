package game

import rl "vendor:raylib"
import "core:fmt"

@(private = "file")
TEXT_GAME_OVER :: "GAME OVER"

@(private = "file")
TEXT_GAME_OVER_SIZE :: 24

@(private = "file")
TEXT_HINT :: "Press %s to restart"

@(private = "file")
TEXT_HINT_SIZE :: 16 

@(private = "file")
DEFAULT_KEY_HINT :: "ENTER"

@(private = "file")
DEFAULT_SCORE_SIZE :: 16

draw_game_over_screen :: proc(position: Vec2i, width, height: i32, key_hint: cstring = DEFAULT_KEY_HINT) {
	rl.DrawRectangle(position.x, position.y, width, height, rl.BLACK)

	text_pos: Vec2i = {
		position.x + calc_text_x_pos(TEXT_GAME_OVER, width, TEXT_GAME_OVER_SIZE),
		position.y + (TEXT_GAME_OVER_SIZE + TEXT_HINT_SIZE) / 2,
	}

	rl.DrawText(TEXT_GAME_OVER, text_pos.x, text_pos.y, TEXT_GAME_OVER_SIZE, rl.RED)

	hint := rl.TextFormat(TEXT_HINT, key_hint)
    text_pos = {
        position.x + calc_text_x_pos(hint, width, TEXT_HINT_SIZE),
        text_pos.y + TEXT_GAME_OVER_SIZE
    }

	rl.DrawText(hint, text_pos.x, text_pos.y, TEXT_HINT_SIZE, rl.GRAY)
}

@(private = "file")
calc_text_x_pos :: proc(text: cstring, width: i32, text_size: i32) -> i32{
    if text == nil {
        return -1
    }

    text_length := rl.MeasureText(text, text_size)
    return (width - text_length) / 2
}

draw_score :: proc(position: Vec2i, width: i32, score: i32) {
    score_str := fmt.ctprintf("Score: %i", score)
    rl.DrawRectangle(position.x, position.y, width, DEFAULT_SCORE_SIZE, rl.BLACK)
    rl.DrawText(score_str, position.x, position.y, DEFAULT_SCORE_SIZE, rl.MAGENTA)
}