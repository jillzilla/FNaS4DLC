class_name NightmareCream extends Node

@export var loading : Control = null;

#variables
@export_group("Status")
@export var currentPosition : int = 0;

var timerChangePosition : float = 0;

@export var SkipMovementChance : float;

@export var minTimerChangePosition : float;
@export var maxTimerChangePosition : float;

@export var jumpscareExposureLevel : int = 0;
@export var jumpscareExposure : float = 0;

@export_group("Sprites")
@export var Position1 : Sprite2D;
@export var Position2 : Sprite2D;
@export var Position3 : Sprite2D;

@export_group("Mechanicals")
@export var ventSFX : AudioStreamPlayer2D;
@export var stepSfx : AudioStreamPlayer2D;
@export var ventLSFX : AudioStreamPlayer;
@export var shockSFX : AudioStreamPlayer;
@export var flashlight : FlashLightComponent;
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var RunGraphics : Node2D;
@export var jumpscareAnimation : AnimationPlayer;
@export var peekingAnimation : AnimationPlayer;
@export var timerStep : Timer;

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
	je = jumpscareExposure;
	
	timerStep.connect("timeout",_made_a_step);
	#character setup
	_handle_positions();

func _process(delta: float) -> void:
	var NewDelta : float = delta * main.fpsTarget;

	if main.NightmareCreamAiLevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareCreamAiLevel;
			if timerChangePosition <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				if main.random_chance(SkipMovementChance):
					ventSFX.play();
					currentPosition += 1;
					_handle_positions();
		elif currentPosition >= positionsAvailable && hasShocked && main.PlayerPosition == "Desk" && !main.ncDeskWalking:
			main.ncDeskWalking = true;
			RunGraphics.position.x = 1240;
			RunGraphics.visible = true;
			timerStep.start();
			var t : Tween = create_tween();
			t.tween_property(RunGraphics,"position:x",-1240,4);
			await t.finished;
			timerStep.stop();
			ventLSFX.play();
			RunGraphics.visible = false;
			RunGraphics.scale.x = 1;
			RunGraphics.position.x = 0;
			timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
			jumpscareExposure = je;
			currentPosition = 0;
			main.ncDeskWalking = false;
			_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking && !main.nlnDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Cream";
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
				GlobalAudioManager.get_node("Cream_Jumpscare").play();
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
			
func _made_a_step() -> void:
	stepSfx.play();
