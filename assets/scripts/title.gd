extends Node

#variables
@onready var animations: AnimationPlayer = $AnimationPlayer;

@onready var nightcounter: Label = $UI/Control/ButtonsContainer/MainButtons/Play/NightCounter;

@onready var star1: Sprite2D = $UI/Control/Star_1;
@onready var star2: Sprite2D = $UI/Control/Star_2;
@onready var star3: Sprite2D = $UI/Control/Star_3;

@onready var night6button: Button = $UI/Control/ButtonsContainer/MainButtons/Night6;
@onready var customnightbutton: Button = $UI/Control/ButtonsContainer/MainButtons/CustomNight;
@onready var extrasbutton: Button = $UI/Control/ButtonsContainer/MainButtons/Extras;
@onready var guidebutton: Button = $UI/Control/ButtonsContainer/Guide;

@onready var buttonscontainer: Control = $UI/Control/ButtonsContainer;
@onready var credits: Control = $UI/Credits;
@onready var settings: Control = $UI/Settings;
@onready var guide: Control = $UI/Guide;
@onready var loading: Control = $UI/Loading;

@onready var version_counter: Label = $UI/Control/Version;

#functions
func _ready() -> void:
	DiscordManager._update_details("Title Screen");
	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	version_counter.text = "Ver. " + ProjectSettings.get_setting("application/config/version");
	
	main._reset_ai();
	
	if main.night_to_play > 1:
		guidebutton.show();
	
	if main.night7ending:
		if !main.night6ending:
			main._save_game();
			main.night6ending = true;
		star3.show();
	
	if main.night6ending:
		if !main.night5ending:
			main.night_to_play = 5;
			guide._update_icon_visibility();
			main._save_game();
			main.night5ending = true;
		star2.show();
		customnightbutton.show();
		extrasbutton.show();
	
	if main.night5ending:
		night6button.show();
		star1.show();
	
	nightcounter.text = "Night " + str(main.night_to_play);

func _on_button_pressed() -> void: # play, forgot to name the signal properly oops
	main.nightcounter = main.night_to_play;
	buttonscontainer.hide();
	animations.play("ChangeScene");
	await animations.animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_night_6_pressed() -> void:
	main.nightcounter = 6;
	buttonscontainer.hide();
	animations.play("ChangeScene");
	await animations.animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_extras_pressed() -> void:
	loading._load_scene("res://assets/scenes/extras.tscn");

func _on_custom_night_pressed() -> void:
	loading._load_scene("res://assets/scenes/custom_night.tscn");

func _on_settings_pressed() -> void:
	settings.show();

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_credits_pressed() -> void:
	credits.show();

func _on_guide_pressed() -> void:
	guide.show();