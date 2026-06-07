extends Node

@onready var loading : Control = $UI/Loading;

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
@export var guidebutton : Button;

@export var credits : Control;

@export var settings : Control;
@export var guide : Control;

#functions
func _ready() -> void:
	DiscordManager._update_details("Title Screen");
	DiscordManager._update_state("");
	
	if main.night_to_play > 1:
		guidebutton.visible = true;
	
	if main.night5ending:
		night6button.visible = true;
		star1.visible = true;
	
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
	
	nightcounter.text = "Night " + str(main.night_to_play);

func _on_button_pressed() -> void: #play, forgot to name the signal properly oops
	main.nightcounter = main.night_to_play;
	
	buttonscontainer.visible = false;
	animations.play("ChangeScene");
	await animations.animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_night_6_pressed() -> void:
	main.nightcounter = 6;
	
	buttonscontainer.visible = false;
	animations.play("ChangeScene");
	await animations.animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_extras_pressed() -> void:
	loading._load_scene("res://assets/scenes/extras.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_custom_night_pressed() -> void:
	loading._load_scene("res://assets/scenes/custom_night.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_settings_pressed() -> void:
	settings.show();

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_credits_pressed() -> void:
	credits.visible = true;

func _on_guide_pressed() -> void:
	guide.show();
