extends Node

#functions
func _ready() -> void:
	GlobalAudioManager.get_node("Ambience").stop();
	_handle_gameover_art();
	
	DiscordManager._update_details("Game Over Screen");
	DiscordManager._update_state("Killed by " + main.killedBy);
	
	main._reset_ai();

func _on_try_again_button_pressed() -> void:
	get_node("Control/TryAgainButton").visible = false;
	get_node("Control/MenuButton").visible = false;
	
	get_node("Fade/AnimationPlayer").play("fade");
	await get_node("Fade/AnimationPlayer").animation_finished;

	get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");

func _on_menu_button_pressed() -> void:
	get_node("Control/TryAgainButton").visible = false;
	get_node("Control/MenuButton").visible = false;
	
	get_node("Fade/AnimationPlayer").play("fade");
	await get_node("Fade/AnimationPlayer").animation_finished;
	
	get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
	
func _on_timer_timeout() -> void:
	get_node("Control").visible = true;
	get_node("Static").modulate.a = 0.5;

func _handle_gameover_art() -> void:
	match(main.killedBy):
		"Nightmare Taingle":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/Taingle").visible = true;
		"Nightmare Toy Yoshi":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/ToyYoshi").visible = true;
		"Nightmare Toy Sonic":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/ToySonic").visible = true;
		"Nightmare Toy Mario":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/ToyMario").visible = true;
		"Nightmare Salvage Sonic":
			get_node("AmyDeath").visible = true;
			get_node("Characters/Salvage").visible = true;
