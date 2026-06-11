extends Node

#variables
var time_left : int = 30;

#functions
func _ready() -> void:
	main.play_minigame = false;
	main.didrarescreenhappened = false;
	
	get_node("HUD/Control/Clock").text =  str(time_left).pad_zeros(2);
	
	DiscordManager._update_details("Fun With Plushnic & Plushtails");
	DiscordManager._update_state("Time Left: " + str(time_left) + "s");

func _on_time_left_timeout() -> void:
	time_left -= 1;
	if time_left > 0:
		get_node("Time_Left").start();
	elif time_left >= 0:
		DiscordManager._update_state("Time Left: " + str(time_left) + "s");
		get_node("HUD/Control/Clock").text =  str(time_left).pad_zeros(2);
	elif time_left == 0:
		print("Fuh");
