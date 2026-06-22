extends Node

#variables
@export_group("Status")
@export var currentPosition: int = 0;

var timerChangePosition: float = 0;

@export var minTimerChangePosition: float;
@export var maxTimerChangePosition: float;

var flashCounter: int = 0;
const flashNeeded: int = 5;

var EnteringExposureLevel: int = main.JUMPSCAREEXPOSURELEVELDEFAULT;
var EnteringExposure: float = main.JUMPSCAREEXPOSUREDEFAULT;

@export_group("Sprites")
@export var Position1: Sprite2D;
@export var OfficeSprite: Sprite2D;

@export_group("Mechanicals")
@export var BT_Laugh: AudioStreamPlayer;
@export var ventLSFX: AudioStreamPlayer;
@export var BT_MoveSFXs: Array[AudioStreamPlayer2D];
@export var ventSFX: AudioStreamPlayer2D;
@export var officeRoomTravel: Node;
@export var deskRoomTravel: Node;
@export var flashlight: Node;
@export var Mask: Node2D;
@export var charAway: AnimationPlayer;

var positionsAvailable: int = 1;
var canAttack: bool = false;

var ee: float;

#functions
func _ready() -> void:
	#working variables
	timerChangePosition = randf_range(minTimerChangePosition, maxTimerChangePosition);
	ee = EnteringExposure;
	
	#character setup
	_handle_positions();
	
func _process(delta: float) -> void:
	var NewDelta: float = delta * main.fpsTarget;
	
	if main.NightmareBTAILevel != 0 && main.PlayerAlive && !main.isBTInOffice:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareBTAILevel;
			if timerChangePosition <= 0:
				timerChangePosition = randf_range(minTimerChangePosition, maxTimerChangePosition);
				BT_MoveSFXs.pick_random().play();
				ventSFX.play();
				currentPosition += 1;
				_handle_positions();
		#counter
		if flashCounter >= flashNeeded:
			flashCounter = 0;
			EnteringExposure = ee;
			timerChangePosition = randf_range(minTimerChangePosition, maxTimerChangePosition);
			charAway.play_backwards("fade");
			ventLSFX.play();
			currentPosition = 0;
			_handle_positions();
		#attack
		if canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking && !main.nlnDeskWalking:
			EnteringExposure -= NewDelta * EnteringExposureLevel;
			if EnteringExposure <= 0:
				EnteringExposure = ee;
				main.isBTInOffice = true;
				deskRoomTravel.disabled = true;
				canAttack = false;
				BT_Laugh.play();
				Position1.visible = false;
				OfficeSprite.visible = true;
				if main.PlayerPosition == "Office":
					charAway.play_backwards("fade");
				else:
					if main.PlayerPosition == "Desk":
						officeRoomTravel._travel();
		
func _handle_positions():
	if flashlight.is_on:
		flashlight._turn_off();
		
	match (currentPosition):
		0:
			Position1.visible = false;
			OfficeSprite.visible = false;
			if canAttack:
				canAttack = false;
			if main.isBTInOffice:
				main.isBTInOffice = false;
			BT_Laugh.stop();
		1:
			Position1.visible = true;
			canAttack = true;
