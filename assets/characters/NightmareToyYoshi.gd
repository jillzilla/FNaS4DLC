class_name NightmareToyYoshi extends Node

@export var loading : Control = null;

#variables
@export_group("Status")
@export var currentPosition : int = 0;

var timerChangePosition : float = 0;

@export var minTimerChangePosition : float;
@export var maxTimerChangePosition : float;

var counterExposureLevel : int = main.COUNTEREXPOSURELEVELDEFAULT;
var counterExposure : float = main.COUNTEREXPOSUREDEFAULT;

var jumpscareExposureLevel : int = main.JUMPSCAREEXPOSURELEVELDEFAULT;
var jumpscareExposure : float = main.JUMPSCAREEXPOSUREDEFAULT;

@export_group("Sprites")
@export var Position1 : Sprite2D;
@export var Position2 : Sprite2D;
@export var Position3 : Sprite2D;

@export_group("Mechanicals")
@export var ventSFX : AudioStreamPlayer2D;
@export var ventLSFX : AudioStreamPlayer;
@export var shockSFX : AudioStreamPlayer;
@export var flashlight : FlashLightComponent;
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var jumpscareAnimation : AnimationPlayer;
@export var peekingAnimation : AnimationPlayer;
@export var charAway : AnimationPlayer;

var ce : float;
var je : float;

var positionsAvailable : int = 3;

var jumpscare : bool = false;

var hasPeeked : bool = false;
var hasShocked : bool = false;

var canAttack : bool = false;

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

	if main.NightmareToyYoshiAILevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareToyYoshiAILevel;
			if timerChangePosition <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				ventSFX.play();
				currentPosition += 1;
				_handle_positions();
		#counter
		if currentPosition >= positionsAvailable && Mask.isUsingMask && hasShocked && main.PlayerPosition == "Left_Vent":
			counterExposure -= NewDelta * counterExposureLevel;
			if counterExposure <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				counterExposure = ce;
				jumpscareExposure = je;
				ventLSFX.play();
				currentPosition = 0;
				charAway.play_backwards("fade");
				_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking && !main.nlnDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Toy Yoshi";
				jumpscare = true;
				jumpscareExposure = je;
				main.PlayerAlive = false;
				Position3.visible = false;
				if main.PlayerPosition != "Office":
					if Mask.isUsingMask:
						Mask.get_node("CD_Timer").stop();
						Mask._remove();
						await Mask.MaskIsRemoved;
					officeRoomTravel._travel();
					await officeRoomTravel.doneTraveling;
				jumpscareAnimation.play("jumpscare");
				GlobalAudioManager.get_node("Yoshi_Jumpscare").play();
				await jumpscareAnimation.animation_finished;
				loading._load_scene("res://assets/scenes/gameover.tscn");
				await loading.scene_loaded;
				get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
		#special events
		if currentPosition == 1: #peeking
			if flashlight.is_on && !hasPeeked:
				hasPeeked = true;
				peekingAnimation.play("Peeking");
		if currentPosition == 3: #shocking
			if flashlight.is_on && !hasShocked:
				hasShocked = true;
				shockSFX.play();
				
func _handle_positions() -> void:
	if flashlight.is_on:
		flashlight._turn_off();
		
	match(currentPosition):
		0:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			if hasPeeked:
				hasPeeked = false;
			if hasShocked:
				hasShocked = false;
			if canAttack:
				canAttack = false;
		1:
			Position1.visible = true;
			Position2.visible = false;
			Position3.visible = false;
		2:
			Position1.visible = false;
			Position2.visible = true;
			Position3.visible = false;
		3:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = true;
			canAttack = true;
