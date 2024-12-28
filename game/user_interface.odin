package game

import rl "vendor:raylib"

draw_game_over_screen :: proc() {
    rl.DrawText("Game Over", 4, 4, 24, rl.RED)
    rl.DrawText("Press ENTER to restart", 4, 30, 16, rl.BLACK)
}