extends Node

#functions
func _ready() -> void:
	DiscordManager._update_details("Intro Screen");
	DiscordManager._update_state("");

func _on_button_pressed() -> void:
	if main.introscenewatched:
		get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
	else:
		get_tree().change_scene_to_file("res://assets/scenes/introcutscene.tscn");
