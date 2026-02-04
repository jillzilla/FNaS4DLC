class_name SalvageSonic extends Node

signal moved;

#variables
@export_group("Status")
@export var currentPosition : int = 0;

var timerChangePosition : float = 0;

@export var SkipMovementChance : float;

@export var minTimerChangePosition : float;
@export var maxTimerChangePosition : float;

@export var counterExposureLevel : int = 0;
@export var counterExposure : float = 0;

@export var jumpscareExposureLevel : int = 0;
@export var jumpscareExposure : float = 0;

@export_group("Sprites")
@export var Position1 : Sprite2D;
@export var Position2 : Sprite2D;
@export var Position3 : Sprite2D;
@export var Position4 : Sprite2D;
@export var Position5 : Sprite2D;
@export var Position6 : Sprite2D;
@export var Position7 : Sprite2D;

@export_group("Mechanicals")
@export var monitor : Node2D;
@export var laugh : AudioStreamPlayer;
@export var flashlight : FlashLightComponent;
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var jumpscareAnimation : AnimationPlayer;

var ce : float;
var je : float;

var positionsAvailable : int = 6;

var canAttack : bool = false;
var jumpscare : bool = false;

#functions
func _ready() -> void:
	#working variables
	timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
	ce = counterExposure;
	je = jumpscareExposure;
	
	#character setup
	_handle_positions();
	
func _process(delta: float) -> void:
	var NewDelta : float = delta * main.fpsTarget;

	if main.NightmareSalvageAiLevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable && !monitor.didSignalLost:
			timerChangePosition -= NewDelta * main.NightmareSalvageAiLevel;
			if timerChangePosition <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				if main.random_chance(SkipMovementChance):
					currentPosition += 1;
					_handle_positions();
					if currentPosition < 6:
						moved.emit();
	
func _handle_positions():
	if flashlight.is_on && currentPosition > 4:
		flashlight._turn_off();
		
	match(currentPosition):
		0:
			Position1.visible = true;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = false;
			if canAttack:
				canAttack = false;
		1:
			Position1.visible = false;
			Position2.visible = true;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = false;
		2:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = true;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = false;
		3:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = true;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = false;
		4:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = true;
			Position6.visible = false;
			Position7.visible = false;
		5:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = true;
			Position7.visible = false;
			laugh.play();
		6:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = true;
			canAttack = true;
