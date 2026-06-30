extends Node

signal ai_value_changed;

#variables
@export var characters: Array[VBoxContainer];

@onready var loading: Control = $Loading;

@onready var challenge_name: Label = $Control/Challenges/Challenge_Name;

@onready var red_star1: TextureRect = $Control/Challenges/Star1;
@onready var red_star2: TextureRect = $Control/Challenges/Star2;

@onready var all_min: Button = $Control/AILevelSetupButtons/Min;
@onready var all_max: Button = $Control/AILevelSetupButtons/Max;
@onready var random: Button = $Control/AILevelSetupButtons/Random;

var challenge_id: int = 0;

#functions
func _ready() -> void:
	DiscordManager._update_details("Custom Night Menu");
	DiscordManager._update_state("");

	connect("ai_value_changed", _ai_value_changed);

	for c in characters:
		c.connect("ai_value_changed", _ai_value_changed);

func _on_back_pressed() -> void:
	loading._load_scene("res://assets/scenes/title.tscn");

func _on_ready_pressed() -> void:
	main.nightcounter = 7;
	main.cnchallenge = challenge_name.text;
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_min_pressed() -> void:
	for c in characters:
		c._set_min();
	ai_value_changed.emit();

func _on_max_pressed() -> void:
	for c in characters:
		c._set_max();
	ai_value_changed.emit();

func _on_random_pressed() -> void:
	for c in characters:
		c._set_random();
	ai_value_changed.emit();

func _on_left_pressed() -> void:
	challenge_id -= 1;

	if challenge_id < 0:
		challenge_id = main._get_challenges_as_array().size() - 1;
	
	_update_stuff();

func _on_right_pressed() -> void:
	challenge_id += 1;

	if challenge_id > main._get_challenges_as_array().size() - 1:
		challenge_id = 0;

	_update_stuff();

func _update_stuff(update_ai: bool = true) -> void:
	challenge_name.text = main._get_challenges_as_array()[challenge_id];

	if challenge_name.text != "Custom Night":
		if update_ai:
			for i in range(main._get_ai_level_as_array().size()):
				main.ai_levels[main._get_ai_level_as_array()[i]] = main.ai_custom_night_challenges[challenge_name.text][main._get_ai_level_as_array()[i]];

		all_min.hide();
		all_max.hide();
		random.hide();

		for c in characters:
			c._update_ai_counter();
			c.left_button.hide();
			c.right_button.hide();
	else:
		all_min.show();
		all_max.show();
		random.show();

		for c in characters:
			c.left_button.show();
			c.right_button.show();
	
	if challenge_name.text != "Custom Night" && main.save_data_file.custom_night_challenges[challenge_name.text] == true:
		red_star1.show();
		red_star2.show();
	elif challenge_name.text == "Custom Night" || challenge_name.text != "Custom Night" && main.save_data_file.custom_night_challenges[challenge_name.text] == false:
		red_star1.hide();
		red_star2.hide();

func _ai_value_changed() -> void:
	var challenge_to_load: int = 0;

	for i in range(main._get_challenges_as_array().size()):
		if main._get_challenges_as_array()[i] != "Custom Night":
			for j in range(main._get_ai_level_as_array().size()):
				if main.ai_levels[main._get_ai_level_as_array()[j]] == main.ai_custom_night_challenges[main._get_challenges_as_array()[i]][main._get_ai_level_as_array()[j]]:
					if challenge_to_load != i:
						challenge_to_load = i;
				else:
					continue ;
		else:
			continue ;
	
	if challenge_to_load > 0:
		challenge_id = challenge_to_load;
		_update_stuff(false);