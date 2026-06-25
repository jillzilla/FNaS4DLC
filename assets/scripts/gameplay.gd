extends Node

#variables
@export var custom_night_rewards: Array[Sprite2D] = [];
@onready var monitor: Node2D = $Rooms/Office/Monitor;

#functions
func _ready() -> void:
	DiscordManager._update_details("Surviving Night " + str(main.nightcounter));
	
	var cndata: Array[bool] = [main.cn_challenge_1, main.cn_challenge_2, main.cn_challenge_3, main.cn_challenge_4, main.cn_challenge_5, main.cn_challenge_6, main.cn_challenge_7, main.cn_challenge_8, main.cn_challenge_9, main.cn_challenge_10, main.cn_challenge_11, main.cn_challenge_12];

	if main.night_to_play >= 3:
		monitor.show();
	
	for i in range(custom_night_rewards.size()):
		custom_night_rewards[i].visible = cndata[i];