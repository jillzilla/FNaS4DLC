extends Node

#functions
func _ready() -> void:
	GlobalAudioManager.get_node("Ambience").stop();

func _on_timer_timeout() -> void:
	get_node("Control/Clock_2/AnimationPlayer").play("lowtaperfade");

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "win":
		if !main.isPlayingCustomNight:
			main.isPlayingCustomNight = false;
			get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");
		else:
			get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
