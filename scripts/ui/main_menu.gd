extends Control

@onready var coins_label: Label = $VBox/CoinsLabel
@onready var play_button: Button = $VBox/PlayButton
@onready var garage_button: Button = $VBox/GarageButton


func _ready() -> void:
	coins_label.text = "Coins: %d" % SaveManager.coins
	play_button.pressed.connect(_on_play_pressed)
	garage_button.pressed.connect(_on_garage_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")


func _on_garage_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/garage/garage.tscn")
