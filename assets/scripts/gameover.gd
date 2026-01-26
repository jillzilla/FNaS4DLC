extends Node

#functions
func _ready() -> void:
	GlobalAudioManager.get_node("Ambience").stop();
	_handle_gameover_art();

func _on_timer_timeout() -> void:
	get_node("Control").visible = true;
	get_node("Static").modulate.a = 0.5;

func _on_try_again_button_pressed() -> void:
	get_node("Control/TryAgainButton").visible = false;
	get_node("Control/MenuButton").visible = false;
	
	get_node("Fade/AnimationPlayer").play("fade");
	await get_node("Fade/AnimationPlayer").animation_finished;

	get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");

func _handle_gameover_art() -> void:
	match(main.killedBy):
		"Nightmare Taingle":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/Taingle").visible = true;
