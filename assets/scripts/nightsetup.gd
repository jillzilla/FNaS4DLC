extends Node

#variables
@export var officeRoomTravel : RoomTravelComponent;

@export var ClockTimer : Timer;
@export var ClockCounter : Label;

var ClockIteration : int = 0;
var ClockOutputs : Array[String] = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM"];

#functions
func _ready() -> void:
	main.killedBy = "";
	main.PlayerAlive = true;
	main.PlayerPosition = officeRoomTravel.room.name;
	main.PlayerNotMoving = true;

func _on_clock_timer_timeout() -> void:
	ClockIteration += 1;
	if ClockIteration < 8:
		ClockCounter.text = ClockOutputs[ClockIteration];
		ClockTimer.start();
	elif ClockIteration == 8:
		get_tree().change_scene_to_file("res://assets/scenes/win_screen.tscn");
