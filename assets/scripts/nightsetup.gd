extends Node

#variables
@onready var loading: Control = $Misc/GUI/Loading;
@export var custom_night_rewards: Array[Sprite2D];

@export var charAway: AnimationPlayer;

@export var entrance_luiginette_sound: AudioStreamPlayer;
@export var clock_falling_animation: AnimationPlayer;

@export var shockSFX: AudioStreamPlayer;
@export var ventleaveSFX: AudioStreamPlayer;
@export var leftventSFX: AudioStreamPlayer2D;
@export var rightventSFX: AudioStreamPlayer2D;

@export var officeRoomTravel: RoomTravelComponent;

@export var ClockTimer: Timer;
@export var ClockCounter: Label;

var ClockIteration: int = 0;
var ClockOutputs: Array[String] = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM"];

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

#functions
func _ready() -> void:
	DiscordManager._update_details("Night " + str(main.nightcounter));
	DiscordManager._update_state(ClockOutputs[ClockIteration]);
	
	var cndata: Array[bool] = [main.cn_challenge_1, main.cn_challenge_2, main.cn_challenge_3, main.cn_challenge_4, main.cn_challenge_5, main.cn_challenge_6, main.cn_challenge_7, main.cn_challenge_8, main.cn_challenge_9, main.cn_challenge_10, main.cn_challenge_11, main.cn_challenge_12];
	for i in range(custom_night_rewards.size()):
		custom_night_rewards[i].visible = cndata[i];

func _on_clock_timer_timeout() -> void:
	ClockIteration += 1;
	
	# if ClockIteration == 4:
	# 	if main.nightcounter == 5:
	# 		charAway.play_backwards("fade");
	# 		shockSFX.stop();
	# 		ventleaveSFX.stop();
	# 		leftventSFX.stop();
	# 		rightventSFX.stop();
	# 		for i in range(characters.size()):
	# 			if i != 7:
	# 				main.aiLevelsAsArrays[i] = 0;
	# 				characters[i].currentPosition = 0;
	# 				main._update_ai_levels();
	# 				characters[i]._handle_positions();
	# 		entrance_luiginette_sound.play();
	# 		clock_falling_animation.play("fall");
	# 		characters[7].movement_opportunity_timer.start();
	# 		main._update_ai_levels();
			
	if ClockIteration < 8:
		_increase_ai_aggressiveness();
		ClockCounter.text = ClockOutputs[ClockIteration];
		DiscordManager._update_state(ClockOutputs[ClockIteration]);
		ClockTimer.start();
	elif ClockIteration >= 8:
		_win();

func _increase_ai_aggressiveness() -> void:
	if main.nightcounter > 0 && main.nightcounter < 7:
		for i in range(main._get_ai_level_as_array().size()):
			if main.ai_levels[main._get_ai_level_as_array()[i]] > 0 && i != 7: # skipping luiginette
				rng.randomize();
				
				if rng.randf() <= 0.5:
					main.ai_levels[main._get_ai_level_as_array()[i]] += 1;
				else:
					main.ai_levels[main._get_ai_level_as_array()[i]] += 2;

				if main.ai_levels[main._get_ai_level_as_array()[i]] > main.AIMAXVALUE:
					main.ai_levels[main._get_ai_level_as_array()[i]] = main.AIMAXVALUE;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SKIPNIGHT"):
		_win();

func _win() -> void:
	GlobalAudioManager.get_node("Ambience").stop();
	get_tree().paused = true;
	loading._load_scene("res://assets/scenes/win_screen.tscn");