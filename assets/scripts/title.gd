extends Node

#functions
func _ready() -> void:
	DiscordManager._update_details("Title Screen");
	DiscordManager._update_state("");
	
	if main.night7ending:
		if !main.night6ending:
			main.night6ending = true;
		get_node("UI/Control/Star_3").visible = true;
		
	if main.night6ending:
		if !main.night5ending:
			main.night5ending = true;
		get_node("UI/Control/Star_2").visible = true;
		get_node("UI/Control/ButtonsContainer/MainButtons/CustomNight").visible = true;
		get_node("UI/Control/ButtonsContainer/MainButtons/Extras").visible = true;
	
	if !main.night5ending:
		get_node("UI/Control/ButtonsContainer/MainButtons/Play/NightCounter").text = str(main.nightcounter) + "th" + " Night";
	else:
		get_node("UI/Control/Star_1").visible = true;
		get_node("UI/Control/ButtonsContainer/MainButtons/Play/NightCounter").text = "5" + "th" + " Night";
		get_node("UI/Control/ButtonsContainer/MainButtons/Night6").visible = true;

func _on_button_pressed() -> void: #play, forgot to name the signal properly oops
	if main.night5ending:
		main.nightcounter = 5;
		
	get_node("UI/Control/ButtonsContainer").visible = false;
	get_node("AnimationPlayer").play("ChangeScene");
	await get_node("AnimationPlayer").animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");

func _on_night_6_pressed() -> void:
	main.nightcounter = 6;
	
	get_node("UI/Control/ButtonsContainer").visible = false;
	get_node("AnimationPlayer").play("ChangeScene");
	await get_node("AnimationPlayer").animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");

func _on_extras_pressed() -> void:
	pass # Replace with function body.

func _on_custom_night_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/custom_night.tscn");

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit();
