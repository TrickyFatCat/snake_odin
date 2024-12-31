package game

import rl "vendor:raylib"

@(private = "file")
eat_sound: rl.Sound

@(private = "file")
crash_sound: rl.Sound

load_eat_sound :: proc(sound_file: cstring) {
	if sound_file == nil {
		return
	}

	eat_sound = rl.LoadSound(sound_file)
}

load_crash_sound :: proc(sound_file: cstring) {
	if sound_file == nil {
		return
	}

	crash_sound = rl.LoadSound(sound_file)
}

play_eat_sound :: proc() {
	rl.PlaySound(eat_sound)
}

play_crash_sound :: proc() {
	rl.PlaySound(crash_sound)
}

unload_sounds :: proc() {
	rl.UnloadSound(eat_sound)
	rl.UnloadSound(crash_sound)
}
