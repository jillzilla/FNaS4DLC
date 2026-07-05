extends Node

#variables
@onready var clockanimation: AnimationPlayer = $Control/Clock_2/AnimationPlayer;

@onready var loading: Control = $Loading;

var next_scene_path: String = "";

#functions
func _ready() -> void:
	DiscordManager._update_details("8 AM!");

	if main.nightcounter != 7:
		DiscordManager._update_state("Night " + str(main.nightcounter));
	else:
		DiscordManager._update_state("Custom Night");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();

	match (main.nightcounter):
		1:
			if !main.save_data_file.guideunlocked:
				RewardUnlockPopup.add_to_queue("Character Guide");
				main.save_data_file.guideunlocked = true;
		5:
			if !main.save_data_file.night5ending:
				RewardUnlockPopup.add_to_queue("Red Star");
				RewardUnlockPopup.add_to_queue("Night 6");
				main.save_data_file.night5ending = true;
		6:
			if !main.save_data_file.night6ending:
				RewardUnlockPopup.add_to_queue("Red Star");
				RewardUnlockPopup.add_to_queue("Extras");
				RewardUnlockPopup.add_to_queue("Custom Night");
				RewardUnlockPopup.add_to_queue("Nightmare Knuckles", "uid://c5khrsuiokdwp");
				RewardUnlockPopup.add_to_queue("Tails Doll", "uid://ckobrpmtwjc7b");
				main.save_data_file.night6ending = true;
		7:
			if main.cnchallenge == "Hammer Heartbreak II":
				if !main.save_data_file.night7ending:
					RewardUnlockPopup.add_to_queue("Gold Star", "uid://c56g28iss4uvm");
					main.save_data_file.night7ending = true;
			if main.cnchallenge != "Custom Night" && main.cnchallenge != "":
				if !main.save_data_file.custom_night_challenges[main.cnchallenge]:
					if main.cnchallenge != "Hammer Heartbreak II":
						RewardUnlockPopup.add_to_queue("Blue Star", "uid://4q8qnis67n2l");
					RewardUnlockPopup.add_to_queue(main._custom_night_rewards[main.cnchallenge]["Text"], main._custom_night_rewards[main.cnchallenge]["Icon"]);
					main.save_data_file.custom_night_challenges[main.cnchallenge] = true;

	RewardUnlockPopup.showcase();
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
		return "uid://cl7jf3xdjegaf";
	elif main.nightcounter == 5:
		return "uid://cm7mi8q4xlx5k";
	elif main.nightcounter == 6:
		return "uid://bdxfeqwt3r0b2";
	elif main.nightcounter == 7 && main.cnchallenge == "Hammer Heartbreak II":
		return "uid://bqrgh7e42cck1";
	else:
		return "uid://bocmtkamvkla5";

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "win":
		loading._load_scene(next_scene_path);