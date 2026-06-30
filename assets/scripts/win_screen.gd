extends Node

#variables
@onready var clockanimation: AnimationPlayer = $Control/Clock_2/AnimationPlayer;

@onready var loading: Control = $Loading;

var next_scene_path: String = "";

#functions
func _ready() -> void:
	DiscordManager._update_details("8 AM!");
	DiscordManager._update_state("Night " + str(main.nightcounter));

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	if main.cnchallenge != "Custom Night" && main.cnchallenge != "":
		if !main.save_data_file.custom_night_challenges[main.cnchallenge]:
			main.save_data_file.custom_night_challenges[main.cnchallenge] = true;

	match (main.nightcounter):
		1:
			if !main.save_data_file.guideunlocked:
				RewardUnlockPopup.add_to_queue("Character Guide");
				RewardUnlockPopup.showcase();
				main.save_data_file.guideunlocked = true;
		5:
			if !main.save_data_file.night5ending:
				RewardUnlockPopup.add_to_queue("Red Star #1");
				RewardUnlockPopup.add_to_queue("Night 6");
				RewardUnlockPopup.showcase();
				main.save_data_file.night5ending = true;
		6:
			if !main.save_data_file.night6ending:
				RewardUnlockPopup.add_to_queue("Red Star #2");
				RewardUnlockPopup.add_to_queue("Extras");
				RewardUnlockPopup.add_to_queue("Custom Night");
				RewardUnlockPopup.add_to_queue("Nightmare Knuckles", "res://assets/images/customnight/knuxicon.png");
				RewardUnlockPopup.add_to_queue("Tails Doll", "res://assets/images/customnight/tdollicon.png");
				RewardUnlockPopup.showcase();
				main.save_data_file.night6ending = true;
		7:
			if main.cnchallenge == "Hammer Heartbreak II":
				if !main.save_data_file.night7ending:
					main.save_data_file.night7ending = true;

	next_scene_path = _get_next_scene();
	
	if !main.save_data_file.night5ending:
		main.save_data_file.night_to_play += 1;
		if main.nightcounter != main.save_data_file.night_to_play:
			main.nightcounter = main.save_data_file.night_to_play;

	main._save();

func _on_timer_timeout() -> void:
	clockanimation.play("lowtaperfade");

func _get_next_scene() -> String:
	if main.nightcounter < 5 && main.save_data_file.night5ending || main.nightcounter == 7 && main.cnchallenge != "Hammer Heartbreak II":
		return "res://assets/scenes/title.tscn";
	elif main.nightcounter == 5:
		return "res://assets/scenes/night_5_ending.tscn";
	elif main.nightcounter == 6:
		return "res://assets/scenes/night_6_ending.tscn";
	elif main.nightcounter == 7 && main.cnchallenge == "Hammer Heartbreak II":
		return "res://assets/scenes/night_6_ending.tscn";
	else:
		return "res://assets/scenes/night_screen.tscn";

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "win":
		loading._load_scene(next_scene_path);