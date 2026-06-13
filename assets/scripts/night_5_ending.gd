extends Node

#variables
@onready var loading : Control = $GUI/Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Night 5 Ending");
	DiscordManager._update_state("");

func _on_button_pressed() -> void:
	loading._load_scene("res://assets/scenes/title.tscn");
