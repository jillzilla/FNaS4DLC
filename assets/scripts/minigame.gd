extends Node

@export var loading : Control;

#variables
@export var plushnic : PlushCharacter;
@export var plushtails : PlushCharacter;

var time_left : int = 0;
var hours_reward : int = 0;

#functions
func _ready() -> void:
	main.didrarescreenhappened = false;
	
	main.killedBy = "";
	main.PlayerAlive = true;
	main.didrarescreenhappened = false;
	
	match(main.night_to_play):
		2:
			time_left = 30;
			get_node("Timer_Power_Drain").wait_time = 0.5;
			hours_reward = 1;
			plushnic.movement_opportunity_rate = 25;
			plushtails.movement_opportunity_rate = 30;
		3:
			time_left = 45;
			get_node("Timer_Power_Drain").wait_time = 0.5;
			hours_reward = 1;
			plushnic.movement_opportunity_rate = 35;
			plushtails.movement_opportunity_rate = 40;
		4:
			time_left = 60;
			get_node("Timer_Power_Drain").wait_time = 0.25;
			hours_reward = 2;
			plushnic.movement_opportunity_rate = 55;
			plushtails.movement_opportunity_rate = 60;
		5:
			time_left = 90;
			get_node("Timer_Power_Drain").wait_time = 0.25;
			hours_reward = 2;
			plushnic.movement_opportunity_rate = 75;
			plushtails.movement_opportunity_rate = 80
		_:
			time_left = 30;
			get_node("Timer_Power_Drain").wait_time = 0.5;
			hours_reward = 1;
			plushnic.movement_opportunity_rate = 25;
			plushtails.movement_opportunity_rate = 30;
			
	get_node("HUD/Control/Clock").text =  str(time_left).pad_zeros(2);
	
	DiscordManager._update_details("Fun With Plushnic & Plushtails");
	DiscordManager._update_state("Time Left: " + str(time_left) + "s");

func _on_time_left_timeout() -> void:
	time_left -= 1;
	
	if time_left > 0:
		get_node("Time_Left").start();
	
	if time_left >= 0:
		DiscordManager._update_state("Time Left: " + str(time_left) + "s");
		get_node("HUD/Control/Clock").text =  str(time_left).pad_zeros(2);
	
	if time_left == 0:
		$HUD/PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED;
		$FlashlightComponentMinigame.process_mode = Node.PROCESS_MODE_DISABLED;
		plushnic.process_mode = Node.PROCESS_MODE_DISABLED;
		plushtails.process_mode = Node.PROCESS_MODE_DISABLED;
		
		if !main.night5ending:
			$HUD/Control/Win/Label2.text = "Reward: -" + str(hours_reward) + " hours on next night!";
			main.hours_2_skip += hours_reward;
		else:
			$HUD/Control/Win/Label2.hide();
		
		DiscordManager._update_state("Great!");
		$HUD/Control/Win.show();
		get_node("Timer_switch_scene").start();

func _on_timer_switch_scene_timeout() -> void:
	if !main.night5ending:
		loading._load_scene("res://assets/scenes/night_screen.tscn");
	else:
		loading._load_scene("res://assets/scenes/title.tscn");
	await loading.scene_loaded;
	GlobalAudioManager.get_node("Ambience_Minigame").stop();
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
