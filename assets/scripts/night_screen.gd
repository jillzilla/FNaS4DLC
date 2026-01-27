extends Node

#functions
func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");
