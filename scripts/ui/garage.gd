extends Control

const BikeCardScene: PackedScene = preload("res://scenes/garage/bike_card.tscn")

@onready var bike_list: VBoxContainer = $Margin/VBox/ScrollContainer/BikeList
@onready var coins_label: Label = $Margin/VBox/TopBar/CoinsLabel
@onready var back_button: Button = $Margin/VBox/TopBar/BackButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_rebuild_list()


func _rebuild_list() -> void:
	for child in bike_list.get_children():
		child.queue_free()

	coins_label.text = "Coins: %d" % SaveManager.coins

	for bike_data in BikeRoster.bikes:
		var card: PanelContainer = BikeCardScene.instantiate()
		bike_list.add_child(card)
		var is_unlocked: bool = SaveManager.is_unlocked(String(bike_data.id))
		var is_selected: bool = SaveManager.selected_bike_id == String(bike_data.id)
		card.setup(bike_data, is_unlocked, is_selected)
		card.select_pressed.connect(_on_select_pressed)
		card.unlock_pressed.connect(_on_unlock_pressed)


func _on_select_pressed(bike_id: StringName) -> void:
	SaveManager.select_bike(String(bike_id))
	_rebuild_list()


func _on_unlock_pressed(bike_id: StringName) -> void:
	var bike_data: BikeData = BikeRoster.get_bike(bike_id)
	if bike_data and SaveManager.unlock(String(bike_id), bike_data.unlock_cost):
		_rebuild_list()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
