extends Node

#functions
func _on_button_pressed() -> void: #play, forgot to name the signal properly oops
	pass # Replace with function body.

func _on_night_6_pressed() -> void:
	pass # Replace with function body.

func _on_extras_pressed() -> void:
	pass # Replace with function body.

func _on_custom_night_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/custom_night.tscn");

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit();
