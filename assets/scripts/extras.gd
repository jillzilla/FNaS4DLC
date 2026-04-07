extends Node

#functions
func _ready() -> void:
	DiscordManager._update_details("Extras");
	DiscordManager._update_state("");

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
