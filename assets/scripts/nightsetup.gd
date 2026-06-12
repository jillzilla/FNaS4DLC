extends Node

@onready var loading : Control = $Misc/GUI/Loading;
@export var custom_night_rewards : Array[Sprite2D];

#variables
@export var characters : Array[Node];
@export var charAway : AnimationPlayer;

@export var entrance_luiginette_sound : AudioStreamPlayer;
@export var clock_falling_animation : AnimationPlayer;

@export var shockSFX : AudioStreamPlayer;
@export var ventleaveSFX : AudioStreamPlayer;
@export var leftventSFX : AudioStreamPlayer2D;
@export var rightventSFX : AudioStreamPlayer2D;

@export var officeRoomTravel : RoomTravelComponent;

@export var ClockTimer : Timer;
@export var ClockCounter : Label;

var ClockIteration : int = 0;
var ClockOutputs : Array[String] = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM"];

#functions
func _ready() -> void:
	if main.hours_2_skip != 0:
		ClockIteration += main.hours_2_skip;
		ClockCounter.text = ClockOutputs[ClockIteration];
		main.hours_2_skip = 0;
	
	DiscordManager._update_details("Night " + str(main.nightcounter));
	DiscordManager._update_state(ClockOutputs[ClockIteration]);
	
	main.killedBy = "";
	main.PlayerAlive = true;
	main.PlayerPosition = officeRoomTravel.room.name;
	main.PlayerNotMoving = true;
	main.ntsDeskRunning = false;
	main.ntmDeskWalking = false;
	main.ncDeskWalking = false;
	main.nlnDeskWalking = false;
	main.isBTInOffice = false;
	main.didrarescreenhappened = false;
	
	var cndata : Array[bool] = [main.cn_challenge_1,main.cn_challenge_2,main.cn_challenge_3,main.cn_challenge_4,main.cn_challenge_5,main.cn_challenge_6,main.cn_challenge_7,main.cn_challenge_8,main.cn_challenge_9,main.cn_challenge_10,main.cn_challenge_11,main.cn_challenge_12];
	
	for i in range(custom_night_rewards.size()):
		custom_night_rewards[i].visible = cndata[i];

func _on_clock_timer_timeout() -> void:
	ClockIteration += 1;
	
	if ClockIteration == 4:
		if main.nightcounter == 5:
			charAway.play_backwards("fade");
			shockSFX.stop();
			ventleaveSFX.stop();
			leftventSFX.stop();
			rightventSFX.stop();
			for i in range(characters.size()):
				if i != 7:
					main.aiLevelsAsArrays[i] = 0;
					characters[i].currentPosition = 0;
					main._update_ai_levels();
					characters[i]._handle_positions();
			entrance_luiginette_sound.play();
			clock_falling_animation.play("fall");
			characters[7].movement_opportunity_timer.start();
			main._update_ai_levels();
			
	if ClockIteration < 8:
		if main.nightcounter != 7:
			for i in range(characters.size()):
				if main.aiLevelsAsArrays[i] != 0 && i != 7:
					if main.random_chance(50):
						main.aiLevelsAsArrays[i] += 1;
					else:
						main.aiLevelsAsArrays[i] += 2;
					if main.aiLevelsAsArrays[i] >= main.AIMAXVALUE:
						main.aiLevelsAsArrays[i] = main.AIMAXVALUE;
			main._update_ai_levels();
		ClockCounter.text = ClockOutputs[ClockIteration];
		DiscordManager._update_state(ClockOutputs[ClockIteration]);
		ClockTimer.start();
		
	elif ClockIteration >= 8:
		get_tree().paused = true;
		loading._load_scene("res://assets/scenes/win_screen.tscn");
		await loading.scene_loaded;
		get_tree().paused = false;
		get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("SKIPNIGHT"):
		#get_tree().paused = true;
		#loading._load_scene("res://assets/scenes/win_screen.tscn");
		#await loading.scene_loaded;
		#get_tree().paused = false;
		#get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
