extends PanelContainer

signal select_pressed(bike_id: StringName)
signal unlock_pressed(bike_id: StringName)

@onready var name_label: Label = $Margin/VBox/NameLabel
@onready var rarity_label: Label = $Margin/VBox/RarityLabel
@onready var stats_label: Label = $Margin/VBox/StatsLabel
@onready var action_button: Button = $Margin/VBox/ActionButton

var _bike: BikeData


func _ready() -> void:
	action_button.pressed.connect(_on_action_pressed)


func setup(bike_data: BikeData, is_unlocked: bool, is_selected: bool) -> void:
	_bike = bike_data
	name_label.text = bike_data.display_name
	rarity_label.text = BikeData.rarity_name(bike_data.rarity)
	rarity_label.add_theme_color_override("font_color", BikeData.rarity_color(bike_data.rarity))
	stats_label.text = "Speed %d%%   Accel %d%%   Handling %d%%" % [
		roundi(bike_data.top_speed_mult * 100),
		roundi(bike_data.acceleration_mult * 100),
		roundi(bike_data.handling_mult * 100),
	]

	if is_selected:
		action_button.text = "SELECTED"
		action_button.disabled = true
	elif is_unlocked:
		action_button.text = "SELECT"
		action_button.disabled = false
	else:
		action_button.text = "UNLOCK - %d coins" % bike_data.unlock_cost
		action_button.disabled = false


func _on_action_pressed() -> void:
	if SaveManager.is_unlocked(String(_bike.id)):
		select_pressed.emit(_bike.id)
	else:
		unlock_pressed.emit(_bike.id)
