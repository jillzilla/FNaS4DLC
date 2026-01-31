extends Node

#functions
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/title.tscn");

func _on_ready_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");
