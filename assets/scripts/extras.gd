extends Node

#variables
@onready var loading: Control = $Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Extras Content Menu");
	DiscordManager._update_state("");

func _on_back_pressed() -> void:
	loading._load_scene("uid://cl7jf3xdjegaf");