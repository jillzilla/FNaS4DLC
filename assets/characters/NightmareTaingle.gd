class_name NightmareTaingle extends Node

#variables
@export_group("Status")
@export var currentPosition : int = 0;

@export var positionChangingRate : float = 0;
@export var timerChangePosition : float = 0;

@export var counterExposureLevel : int = 0;
@export var counterExposure : float = 0;

@export var jumpscareExposureLevel : int = 0;
@export var jumpscareExposure : float = 0;

@export_group("Sprites")
@export var Position1 : Sprite2D;
@export var Position2 : Sprite2D;
@export var Position3 : Sprite2D;
@export var Position4 : Sprite2D;

@export_group("Mechanicals")
@export var flashlight : FlashLightComponent;
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var jumpscareAnimation : AnimationPlayer;
@export var radio : AudioStreamPlayer;

var cp : float;
var ce : float;
var je : float;

var positionsAvailable : int = 4;

var canAttack : bool = false;
var jumpscare : bool = false;

#functions
func _ready() -> void:
	#working variables
	cp = timerChangePosition;
	ce = counterExposure;
	je = jumpscareExposure;
	
	#character setup
	_handle_positions();

func _process(delta: float) -> void:
	var NewDelta : float = delta * main.fpsTarget;

	if main.NightmareTaingleAILevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			if currentPosition > 0 && !flashlight.is_on || currentPosition == 0:
				timerChangePosition -= NewDelta * main.NightmareTaingleAILevel;
				if timerChangePosition <= 0:
					timerChangePosition = cp;
					if main.random_chance(positionChangingRate):
						counterExposure = ce;
						currentPosition += 1;
						_handle_positions();
		#counter
		if currentPosition > 0 && flashlight.is_on && main.PlayerPosition == "Ceiling":
			counterExposure -= NewDelta * counterExposureLevel;
			if counterExposure <= 0:
				timerChangePosition = cp;
				counterExposure = ce;
				jumpscareExposure = je;
				currentPosition -= 1;
				_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Taingle";
				jumpscare = true;
				jumpscareExposure = je;
				main.PlayerAlive = false;
				Position4.visible = false;
				if main.PlayerPosition != "Office":
					if Mask.isUsingMask:
						Mask.get_node("CD_Timer").stop();
						Mask._remove();
						await Mask.MaskIsRemoved;
					officeRoomTravel._travel();
					await officeRoomTravel.doneTraveling;
				radio.volume_db = -80;
				jumpscareAnimation.play("jumpscare");
				GlobalAudioManager.get_node("Taingle_Jumpscare").play();
				await jumpscareAnimation.animation_finished;
				get_tree().change_scene_to_file("res://assets/scenes/gameover.tscn");

func _handle_positions() -> void:
	match(currentPosition):
		0:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			canAttack = false;
			radio.volume_db = -80;
		1:
			Position1.visible = true;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			canAttack = false;
			radio.volume_db = -15;
		2:
			Position1.visible = false;
			Position2.visible = true;
			Position3.visible = false;
			Position4.visible = false;
			canAttack = false;
			radio.volume_db = -10;
		3:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = true;
			Position4.visible = false;
			canAttack = false;
			radio.volume_db = -5;
		4:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = true;
			canAttack = true;
			radio.volume_db = 0;
