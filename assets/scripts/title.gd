extends Node

#variables
@onready var animations: AnimationPlayer = $AnimationPlayer;

@onready var nightcounter: Label = $UI/Control/ButtonsContainer/MainButtons/Play/NightCounter;
@onready var version_counter: Label = $UI/Control/Version;

@onready var star1: Sprite2D = $UI/Control/Star_1;
@onready var star2: Sprite2D = $UI/Control/Star_2;
@onready var star3: Sprite2D = $UI/Control/Star_3;
@onready var star4: Sprite2D = $UI/Control/Star_4;
@onready var platinum_star: Sprite2D = $UI/Control/Star_16;

@onready var night6button: Button = $UI/Control/ButtonsContainer/MainButtons/Night6;
@onready var customnightbutton: Button = $UI/Control/ButtonsContainer/MainButtons/CustomNight;
@onready var extrasbutton: Button = $UI/Control/ButtonsContainer/MainButtons/Extras;
@onready var guidebutton: Button = $UI/Control/ButtonsContainer/Guide;

@onready var buttonscontainer: Control = $UI/Control/ButtonsContainer;
@onready var credits: Control = $UI/Credits;
@onready var settings: Control = $UI/Settings;
@onready var guide: Control = $UI/Guide;
@onready var loading: Control = $UI/Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Title Screen");
	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	version_counter.text = "Ver. " + ProjectSettings.get_setting("application/config/version");
	
	main._reset_ai();
	main.cnchallenge = "";

	if main.save_data_file.endless_mode_completed:
		star4.show();
	
	if main.save_data_file.guideunlocked:
		guidebutton.show();

	if main.save_data_file.max_mode_with_modifiers:
		platinum_star.show();
	
	if main.save_data_file.night7ending:
		if !main.save_data_file.night6ending:
			main.save_data_file.night6ending = true;
			main._save();
		star3.show();
	
	if main.save_data_file.night6ending:
		if !main.save_data_file.night5ending:
			main.save_data_file.night_to_play = 5;
			main.save_data_file.night5ending = true;
			guide._update_icon_visibility();
			main._save();
		star2.show();
		customnightbutton.show();
		extrasbutton.show();
	
	if main.save_data_file.night5ending:
		if !main.save_data_file.guideunlocked:
			main.save_data_file.guideunlocked = true;
			main._save();
		night6button.show();
		star1.show();

	var blue_stars: Array[Sprite2D] = [$UI/Control/Star_5, $UI/Control/Star_6, $UI/Control/Star_7,
	$UI/Control/Star_8, $UI/Control/Star_9, $UI/Control/Star_10, $UI/Control/Star_11, $UI/Control/Star_12,
	$UI/Control/Star_13, $UI/Control/Star_14, $UI/Control/Star_15];
	
	var challenges: Array[String] = ["4/20", "Nintendon't", "Nintendo Power", "Sonic VS. Mario",
	"Friendly Fire", "Sidekick Hangout", "Night Shift in Company", "Panda Mode",
	"Advance 3", "Your Biggest Nightmare", "Grand Re-Opening"];

	for i in range(challenges.size()):
		if main.save_data_file.custom_night_challenges[challenges[i]]:
			blue_stars[i].show();
	
	nightcounter.text = "Night " + str(main.save_data_file.night_to_play);

func _on_button_pressed() -> void: # play, forgot to name the signal properly oops
	main.nightcounter = main.save_data_file.night_to_play;
	buttonscontainer.hide();
	animations.play("ChangeScene");
	await animations.animation_finished;
	loading._load_scene("uid://bocmtkamvkla5");

func _on_night_6_pressed() -> void:
	main.nightcounter = 6;
	buttonscontainer.hide();
	animations.play("ChangeScene");
	await animations.animation_finished;
	loading._load_scene("uid://bocmtkamvkla5");

func _on_extras_pressed() -> void:
	loading._load_scene("uid://bk0janpvstfkp");

func _on_custom_night_pressed() -> void:
	loading._load_scene("uid://bekew5j02li0q");

func _on_settings_pressed() -> void:
	settings.show();

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_credits_pressed() -> void:
	credits.show();

func _on_guide_pressed() -> void:
	guide.show();