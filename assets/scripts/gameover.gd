extends Node

@onready var loading : Control = $Loading;

#functions
func _ready() -> void:
	GlobalAudioManager.get_node("Ambience").stop();
	GlobalAudioManager.get_node("Ambience_Minigame").stop();
	DiscordManager._update_details("Game Over Screen");
	DiscordManager._update_state("Killed by " + main.killedBy);
	
	if main.play_minigame:
		get_node("Control/GameOver").text = "Too Bad..."
		get_node("Control/TryAgainButton").visible = false;
		main.play_minigame = false;
	
	_handle_gameover_art();

func _on_try_again_button_pressed() -> void:
	get_node("Control/TryAgainButton").visible = false;
	get_node("Control/MenuButton").visible = false;
	get_node("Fade/AnimationPlayer").play("fade");
	await get_node("Fade/AnimationPlayer").animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_menu_button_pressed() -> void:
	main._reset_ai();
	get_node("Control/TryAgainButton").visible = false;
	get_node("Control/MenuButton").visible = false;
	get_node("Fade/AnimationPlayer").play("fade");
	await get_node("Fade/AnimationPlayer").animation_finished;
	loading._load_scene("res://assets/scenes/title.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
	
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
		"Nightmare Cream":
			get_node("AmyDeath").visible = true;
			get_node("Characters/Cream").visible = true;
		"Nightmare Luiginette":
			get_node("Overlays/POV").visible = true;
			get_node("Characters/Luigi").visible = true;
		"Nightmare Knuckles":
			get_node("AmyDeath").visible = true;
			get_node("Characters/Knuckles").visible = true;
		"Plushnic":
			get_node("Overlays/POV").visible = true;
			get_node("Characters/Plushnic").visible = true;
		"Plushtails":
			get_node("Overlays/POV").visible = true;
			get_node("Characters/Plushtails").visible = true;
