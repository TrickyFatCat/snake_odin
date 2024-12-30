package game

@(private = "file")
score : i32 = 0

increase_score :: proc(amount: i32 = 1) {
    if amount <= 0 {
        return 
    }

    score += amount
}

reset_score :: proc() {
    score = 0
}

get_score :: proc() -> i32 {
    return score
}