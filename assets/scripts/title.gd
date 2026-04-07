extends Node

#variables
@export var animations : AnimationPlayer;

@export var buttonscontainer : Control;

@export var nightcounter : Label;

@export var star1 : Sprite2D;
@export var star2 : Sprite2D;
@export var star3 : Sprite2D;

@export var night6button : Button;
@export var customnightbutton : Button;
@export var extrasbutton : Button;

@export var credits : Control;

#functions
func _ready() -> void:
	DiscordManager._update_details("Title Screen");
	DiscordManager._update_state("");
	
	if main.night7ending:
		if !main.night6ending:
			main.night6ending = true;
		star3.visible = true;
		
	if main.night6ending:
		if !main.night5ending:
			main.night5ending = true;
		star2.visible = true;
		customnightbutton.visible = true;
		extrasbutton.visible = true;
	
	if !main.night5ending:
		nightcounter.text = "Night " + str(main.nightcounter);
	else:
		star1.visible = true;
		nightcounter.text = "Night 5";
		night6button.visible = true;

func _on_button_pressed() -> void: #play, forgot to name the signal properly oops
	if main.night5ending:
		main.nightcounter = 5;
		
	buttonscontainer.visible = false;
	animations.play("ChangeScene");
	await animations.animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");

func _on_night_6_pressed() -> void:
	main.nightcounter = 6;
	
	buttonscontainer.visible = false;
	animations.play("ChangeScene");
	await animations.animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");

func _on_extras_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/extras.tscn");

func _on_custom_night_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/custom_night.tscn");

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_credits_pressed() -> void:
	credits.visible = true;
