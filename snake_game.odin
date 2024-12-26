package snake_game

import rl "vendor:raylib"
import "core:fmt"

WINDOW_WIDTH :: 1000
WINDOW_HEIGHT :: 1000
WINDOW_NAME : cstring : "Snake"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_NAME)

    for !rl.WindowShouldClose() {

    }

    rl.CloseWindow()
}