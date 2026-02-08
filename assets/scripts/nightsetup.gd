extends Node

#variables
@export var characters : Array[Node];
@export var charAway : AnimationPlayer;

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
	main.isBTInOffice = false;

func _on_clock_timer_timeout() -> void:
	ClockIteration += 1;
	
	if ClockIteration == 4:
		if main.nightcounter == 5:
			charAway.play_backwards("fade");
			
			for i in range(characters.size()):
				if i != 7:
					main.aiLevelsAsArrays[i] = 0;
					characters[i].currentPosition = 0;
					main._update_ai_levels();
					characters[i]._handle_positions();
					
			main.aiLevelsAsArrays[7] = 25;
			main._update_ai_levels();
			
	if ClockIteration < 8:
		ClockCounter.text = ClockOutputs[ClockIteration];
		DiscordManager._update_state(ClockOutputs[ClockIteration]);
		ClockTimer.start();
		
	elif ClockIteration >= 8:
		get_tree().change_scene_to_file("res://assets/scenes/win_screen.tscn");
