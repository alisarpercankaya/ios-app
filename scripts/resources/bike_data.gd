class_name BikeData
extends Resource

## 0=Common 1=Uncommon 2=Rare 3=Epic 4=Legendary
@export var id: StringName
@export var display_name: String = ""
@export_enum("Common", "Uncommon", "Rare", "Epic", "Legendary") var rarity: int = 0

## Multipliers applied to the base gameplay constants in GameConfig/PlayerBike.
@export var top_speed_mult: float = 1.0
@export var acceleration_mult: float = 1.0
@export var handling_mult: float = 1.0

@export var unlock_cost: int = 0
@export var body_color: Color = Color.WHITE


static func rarity_name(rarity_value: int) -> String:
	const NAMES: Array[String] = ["Common", "Uncommon", "Rare", "Epic", "Legendary"]
	return NAMES[clampi(rarity_value, 0, NAMES.size() - 1)]


static func rarity_color(rarity_value: int) -> Color:
	const COLORS: Array[Color] = [
		Color(0.75, 0.75, 0.75),
		Color(0.35, 0.85, 0.4),
		Color(0.3, 0.55, 0.95),
		Color(0.7, 0.35, 0.9),
		Color(0.95, 0.7, 0.15),
	]
	return COLORS[clampi(rarity_value, 0, COLORS.size() - 1)]
