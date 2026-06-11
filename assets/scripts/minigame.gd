extends Node

#functions
func _ready() -> void:
	main.play_minigame = false;
	main.didrarescreenhappened = false;
	DiscordManager._update_details("Fun With Plushnic & Plushtails");
	DiscordManager._update_state("Time Left: 30s");
