extends Node

#functions
func _ready() -> void:
	DiscordManager._update_details("Entering Night " + str(main.nightcounter));
	DiscordManager._update_state("Reading The Tutorial...");

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");
