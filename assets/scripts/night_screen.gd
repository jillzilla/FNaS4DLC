extends Node

#variables
@onready var loading: Control = $Loading;
@export var nightcounter: Label;

@export_file_path("*.json") var data_json: String = "";
var data: Dictionary = {};

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
		main.aiLevelsAsArrays[0] = data["Night " + str(main.nightcounter)]["Nightmare Toy Sonic"];
		main.aiLevelsAsArrays[1] = data["Night " + str(main.nightcounter)]["Nightmare Toy Mario"];
		main.aiLevelsAsArrays[2] = data["Night " + str(main.nightcounter)]["Nightmare Toy Yoshi"];
		main.aiLevelsAsArrays[3] = data["Night " + str(main.nightcounter)]["Nightmare Taingle"];
		main.aiLevelsAsArrays[4] = data["Night " + str(main.nightcounter)]["Nightmare BT"];
		main.aiLevelsAsArrays[5] = data["Night " + str(main.nightcounter)]["Nightmare Salvage"];
		main.aiLevelsAsArrays[6] = data["Night " + str(main.nightcounter)]["Nightmare Cream"];
		main.aiLevelsAsArrays[7] = data["Night " + str(main.nightcounter)]["Nightmare Luiginette"];
		main.aiLevelsAsArrays[8] = data["Night " + str(main.nightcounter)]["Tails Doll"];
		main.aiLevelsAsArrays[9] = data["Night " + str(main.nightcounter)]["Nightmare Knuckles"];
		main._update_ai_levels();

func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		if main.random_chance(95) || main.didrarescreenhappened:
			main.didrarescreenhappened = false;
			if main.nightcounter > 0 && main.nightcounter < 6:
				loading._load_scene("res://assets/scenes/tutorials.tscn");
			else:
				loading._load_scene("res://assets/scenes/gameplay.tscn");
		else:
			loading._load_scene("res://assets/scenes/rare_screens.tscn");
