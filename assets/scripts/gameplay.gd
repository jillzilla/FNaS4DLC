extends Node

#variables
@export var custom_night_rewards : Array[Sprite2D];
@onready var monitor: Node2D = $Rooms/Office/Monitor;

#functions
func _ready() -> void:
	DiscordManager._update_details("Surviving Night " + str(main.nightcounter));

	if main.save_data_file.night_to_play >= 3:
		monitor.show();
	
	for i in range(main._get_challenges_as_array().size()):
		if main._get_challenges_as_array()[i] != "Custom Night":
			if main.save_data_file.custom_night_challenges[main._get_challenges_as_array()[i]]:
				custom_night_rewards[i - 1].show();