extends Node
## Persists coins, unlocked bikes, the selected bike, and the best distance
## as JSON at user://save.json.

const SAVE_PATH: String = "user://save.json"
const STARTING_COINS: int = 300

var coins: int = 0
var unlocked_ids: Array[String] = []
var selected_bike_id: String = ""
var best_distance: float = 0.0


func _ready() -> void:
	_load()


func is_unlocked(bike_id: String) -> bool:
	return unlocked_ids.has(bike_id)


func unlock(bike_id: String, cost: int) -> bool:
	if is_unlocked(bike_id):
		return true
	if coins < cost:
		return false
	coins -= cost
	unlocked_ids.append(bike_id)
	_save()
	return true


func select_bike(bike_id: String) -> void:
	if is_unlocked(bike_id):
		selected_bike_id = bike_id
		_save()


func add_coins(amount: int) -> void:
	coins += amount
	_save()


func report_run_distance(distance: float) -> void:
	if distance > best_distance:
		best_distance = distance
		_save()


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_init_defaults()
		return

	var f: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()

	if typeof(parsed) != TYPE_DICTIONARY:
		_init_defaults()
		return

	coins = int(parsed.get("coins", STARTING_COINS))
	unlocked_ids.clear()
	for raw_id in parsed.get("unlocked_ids", []):
		unlocked_ids.append(String(raw_id))
	selected_bike_id = String(parsed.get("selected_bike_id", ""))
	best_distance = float(parsed.get("best_distance", 0.0))

	if selected_bike_id == "" or not is_unlocked(selected_bike_id):
		_ensure_default_selection()


func _init_defaults() -> void:
	coins = STARTING_COINS
	unlocked_ids.clear()
	best_distance = 0.0
	_ensure_default_selection()
	_save()


func _ensure_default_selection() -> void:
	var default_id: String = String(BikeRoster.get_default_bike_id())
	if default_id == "":
		return
	if not unlocked_ids.has(default_id):
		unlocked_ids.append(default_id)
	selected_bike_id = default_id


func _save() -> void:
	var data: Dictionary = {
		"coins": coins,
		"unlocked_ids": unlocked_ids,
		"selected_bike_id": selected_bike_id,
		"best_distance": best_distance,
	}
	var f: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()
