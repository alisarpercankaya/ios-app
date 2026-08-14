extends Node
## Loads every BikeData resource under resources/bikes/ once at startup and
## indexes it by id.

const BIKES_DIR: String = "res://resources/bikes/"

var bikes: Array[BikeData] = []
var _by_id: Dictionary = {}


func _ready() -> void:
	var dir: DirAccess = DirAccess.open(BIKES_DIR)
	if dir == null:
		push_error("BikeRoster: could not open %s" % BIKES_DIR)
		return

	var paths: Array[String] = []
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			paths.append(BIKES_DIR + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	paths.sort()

	for path in paths:
		var bike: BikeData = load(path)
		bikes.append(bike)
		_by_id[bike.id] = bike


func get_bike(bike_id) -> BikeData:
	return _by_id.get(StringName(bike_id))


func get_default_bike_id() -> StringName:
	return bikes[0].id if not bikes.is_empty() else &""
