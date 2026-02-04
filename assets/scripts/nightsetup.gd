extends Node

#variables
@export var officeRoomTravel : RoomTravelComponent;

@export var ClockTimer : Timer;
@export var ClockCounter : Label;

@export var monitor : Node2D;

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
	main.isBTInOffice = false;
	
	if main.nightcounter < 7:
		_set_ai_levels();
	main._update_ai_levels();
	
	if main.NightmareSalvageAiLevel != 0:
		monitor.visible = true;

func _on_clock_timer_timeout() -> void:
	ClockIteration += 1;
	if ClockIteration < 8:
		ClockCounter.text = ClockOutputs[ClockIteration];
		DiscordManager._update_state(ClockOutputs[ClockIteration]);
		ClockTimer.start();
	elif ClockIteration >= 8:
		get_tree().change_scene_to_file("res://assets/scenes/win_screen.tscn");

func _set_ai_levels() -> void:
	match(main.nightcounter):
		1:
			main.aiLevelsAsArrays[0] = 0;
			main.aiLevelsAsArrays[1] = 5;
			main.aiLevelsAsArrays[2] = 5;
			main.aiLevelsAsArrays[3] = 5;
			main.aiLevelsAsArrays[4] = 0;
			main.aiLevelsAsArrays[5] = 0;
		2:
			main.aiLevelsAsArrays[0] = 5;
			main.aiLevelsAsArrays[1] = 8;
			main.aiLevelsAsArrays[2] = 8;
			main.aiLevelsAsArrays[3] = 8;
			main.aiLevelsAsArrays[4] = 5;
			main.aiLevelsAsArrays[5] = 0;
		3:
			main.aiLevelsAsArrays[0] = 8;
			main.aiLevelsAsArrays[1] = 10;
			main.aiLevelsAsArrays[2] = 10;
			main.aiLevelsAsArrays[3] = 10;
			main.aiLevelsAsArrays[4] = 8;
			main.aiLevelsAsArrays[5] = 5;
		4:
			main.aiLevelsAsArrays[0] = 10;
			main.aiLevelsAsArrays[1] = 12;
			main.aiLevelsAsArrays[2] = 12;
			main.aiLevelsAsArrays[3] = 12;
			main.aiLevelsAsArrays[4] = 10;
			main.aiLevelsAsArrays[5] = 8;
		5:
			main.aiLevelsAsArrays[0] = 12;
			main.aiLevelsAsArrays[1] = 15;
			main.aiLevelsAsArrays[2] = 15;
			main.aiLevelsAsArrays[3] = 15;
			main.aiLevelsAsArrays[4] = 12;
			main.aiLevelsAsArrays[5] = 10;
		6:
			main.aiLevelsAsArrays[0] = 0;
			main.aiLevelsAsArrays[1] = 0;
			main.aiLevelsAsArrays[2] = 0;
			main.aiLevelsAsArrays[3] = 0;
			main.aiLevelsAsArrays[4] = 0;
