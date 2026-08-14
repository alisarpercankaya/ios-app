extends Control

@onready var distance_label: Label = $VBox/DistanceLabel
@onready var near_miss_label: Label = $VBox/NearMissLabel
@onready var coins_label: Label = $VBox/CoinsLabel
@onready var best_label: Label = $VBox/BestLabel
@onready var retry_button: Button = $VBox/ButtonRow/RetryButton
@onready var garage_button: Button = $VBox/ButtonRow/GarageButton
@onready var menu_button: Button = $VBox/ButtonRow/MenuButton


func _ready() -> void:
	distance_label.text = "Distance: %d m" % int(GameState.distance)
	near_miss_label.text = "Near-misses: %d" % GameState.near_miss_count
	coins_label.text = "Coins earned: +%d" % GameState.coins_this_run
	best_label.text = "Best distance: %d m" % int(SaveManager.best_distance)

	retry_button.pressed.connect(_on_retry_pressed)
	garage_button.pressed.connect(_on_garage_pressed)
	menu_button.pressed.connect(_on_menu_pressed)


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")


func _on_garage_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/garage/garage.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
