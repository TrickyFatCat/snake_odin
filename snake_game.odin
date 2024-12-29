package snake_game

import "core:fmt"
import "core:mem"
import "game"
import rl "vendor:raylib"

WINDOW_WIDTH :: 1000
WINDOW_HEIGHT :: 1000
WINDOW_NAME: cstring : "Snake"

// Defaults
DEFAULT_TICK_DURATION :: 0.15
DEFAULT_GRID_SIZE: game.Vec2i : {20, 20}
DEFAULT_CELL_SIZE :: 16

// Visuals
FOOD_SPRITE: cstring : "../assets/sprites/sprite_food.png"
SNAKE_SPRITES: [3]cstring : {
	"../assets/sprites/sprite_head.png",
	"../assets/sprites/sprite_body.png",
	"../assets/sprites/sprite_tail.png",
}

main :: proc() {
	// Taken from www.odin-lang.com
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	//Game
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_NAME)
	rl.SetTargetFPS(60)

	//Initialisation
	tick_timer: f32 = DEFAULT_TICK_DURATION

	grid: game.Grid = {DEFAULT_GRID_SIZE, DEFAULT_CELL_SIZE}
	grid_centre := game.get_grid_centre_pos(&grid)
	canvas_size: i32 = game.calc_canvas_size(&grid)

	is_game_over := false

	snake := game.create_snake(position = grid_centre, sprites = SNAKE_SPRITES)
	food := game.create_food({0, 0}, FOOD_SPRITE)

	game.place_food(food, &grid, snake)

	//Main Loop
	for !rl.WindowShouldClose() {
		//Gameplay
		if is_game_over {
			game.draw_game_over_screen()

			if rl.IsKeyDown(.ENTER) {
				game.reset_snake(snake, length = 3, position = grid_centre)
				game.place_food(food, &grid, snake)
				is_game_over = false
			}
		} else {
			tick_timer -= rl.GetFrameTime()
			game.change_snake_movement_dir(snake, game.calc_snake_dir(snake.movement_dir))
		}

		if tick_timer <= 0.0 && !is_game_over {
			game.move_snake(snake)
			is_game_over = game.is_hitting_wall(snake, &grid) || game.is_hitting_self(snake)

			if game.snake_can_eat(snake, food) {
				game.incrment_snake(snake)
				game.place_food(food, &grid, snake)
			}

			tick_timer = DEFAULT_TICK_DURATION + tick_timer
		}

		//Visuals
		rl.BeginDrawing()
		rl.ClearBackground(rl.GRAY)

		camera := rl.Camera2D {
			zoom = f32(WINDOW_HEIGHT) / f32(canvas_size),
		}

		rl.BeginMode2D(camera)

		if ODIN_DEBUG {
            game.draw_grid(&grid)
		}

		game.draw_snake(snake, grid.cell_size)
		game.draw_food(food, grid.cell_size)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	game.remove_snake(snake)
	game.remove_food(food)
	rl.CloseWindow()
}
