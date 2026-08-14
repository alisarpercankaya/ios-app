extends Node
## Live state for the current run. Reset via reset_run() when a run starts.

signal crashed_changed(is_crashed: bool)

var scroll_speed: float = GameConfig.BASE_FORWARD_SPEED
var distance: float = 0.0
var coins_this_run: int = 0
var near_miss_count: int = 0
var crashed: bool = false


func reset_run() -> void:
	scroll_speed = GameConfig.BASE_FORWARD_SPEED
	distance = 0.0
	coins_this_run = 0
	near_miss_count = 0
	crashed = false
	crashed_changed.emit(false)


func register_near_miss() -> void:
	near_miss_count += 1


func trigger_crash() -> void:
	if crashed:
		return
	crashed = true
	coins_this_run = int(distance / 10.0) * GameConfig.COIN_PER_10M + near_miss_count * GameConfig.COIN_PER_NEAR_MISS
	SaveManager.add_coins(coins_this_run)
	SaveManager.report_run_distance(distance)
	crashed_changed.emit(true)
