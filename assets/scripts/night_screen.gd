extends Node

#variables
@onready var loading: Control = $Loading;
@export var nightcounter: Label;

@export_file_path("*.json") var data_json: String = "";
var data: Dictionary = {};

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

#functions
func _ready() -> void:
	DiscordManager._update_details("Entering Night " + str(main.nightcounter));
	DiscordManager._update_state("");
	
	nightcounter.text = "Night " + str(main.nightcounter) + "\n" + "12:00 AM";
	
	main.killedBy = "";
	main.PlayerAlive = true;
	main.isBTInOffice = false;

	var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
	var json_text: String = file.get_as_text();
	file.close();
	data = JSON.parse_string(json_text);
	
	if main.nightcounter > 0 && main.nightcounter < 7:
		var data_as_array: Array[String] = ["Nightmare Toy Sonic", "Nightmare Toy Mario",
		"Nightmare Toy Yoshi", "Nightmare Taingle", "Nightmare BT", "Nightmare Salvage",
		"Nightmare Cream", "Nightmare Luiginette", "Tails Doll",
		"Nightmare Knuckles"];

		for i in range(data_as_array.size()):
			main.aiLevelsAsArrays[i] = data["Night " + str(main.nightcounter)][data_as_array[i]];

		main._update_ai_levels();

func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		rng.randomize();
		if rng.randf() <= 0.1 && !main.didrarescreenhappened:
			loading._load_scene("res://assets/scenes/rare_screens.tscn");
		else:
			main.didrarescreenhappened = false;
			if main.nightcounter > 0 && main.nightcounter < 6:
				loading._load_scene("res://assets/scenes/tutorials.tscn");
			else:
				loading._load_scene("res://assets/scenes/gameplay.tscn");