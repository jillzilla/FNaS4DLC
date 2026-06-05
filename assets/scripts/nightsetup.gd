extends Node

#variables
@export var characters : Array[Node];
@export var charAway : AnimationPlayer;

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
			main.aiLevelsAsArrays[7] = 48;
			main._update_ai_levels();
			
	if ClockIteration < 8:
		if main.nightcounter != 7:
			for i in range(characters.size()):
				if main.aiLevelsAsArrays[i] != 0:
					if main.random_chance(80):
						main.aiLevelsAsArrays[i] += 1;
					else:
						main.aiLevelsAsArrays[i] += 2;
			main._update_ai_levels();
		ClockCounter.text = ClockOutputs[ClockIteration];
		DiscordManager._update_state(ClockOutputs[ClockIteration]);
		ClockTimer.start();
		
	elif ClockIteration >= 8:
		get_tree().change_scene_to_file("res://assets/scenes/win_screen.tscn");

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SKIPNIGHT"):
		get_tree().change_scene_to_file("res://assets/scenes/win_screen.tscn");
