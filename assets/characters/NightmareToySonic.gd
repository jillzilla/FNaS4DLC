class_name NightmareToySonic extends Node

#variables
enum Directions {NONE,LEFT,RIGHT};
var Direction : Variant = Directions.NONE;

@export_group("Status")
@export var currentPosition : int = 0;

var timerChangePosition : float = 0;

@export var SkipMovementChance : float;

@export var minTimerChangePosition : float;
@export var maxTimerChangePosition : float;

@export var jumpscareExposureLevel : int = 0;
@export var jumpscareExposure : float = 0;

@export_group("Sprites")
@export var LPosition1 : Sprite2D;
@export var LPosition2 : Sprite2D;
@export var RPosition1 : Sprite2D;
@export var RPosition2 : Sprite2D;

@export_group("Mechanicals")
@export var LFlashlight : FlashLightComponent;
@export var RFlashlight : FlashLightComponent;
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var RunGraphics : Node2D;
@export var LVentSFX : AudioStreamPlayer2D;
@export var RVentSFX : AudioStreamPlayer2D;
@export var stepSfx : AudioStreamPlayer2D;
@export var shockSFX : AudioStreamPlayer;
@export var ventLeaveSFX : AudioStreamPlayer;
@export var jumpscareAnimation : AnimationPlayer;
@export var LPeekingAnimation : AnimationPlayer;
@export var RPeekingAnimation : AnimationPlayer;
@export var RunAnimation : AnimationPlayer;
@export var timerStep : Timer;

var je : float;

var positionsAvailable : int = 2;

var jumpscare : bool = false;

var hasPeeked : bool = false;
var hasShocked : bool = false;

var canAttack : bool = false;

#functions
func _ready() -> void:
	timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
	je = jumpscareExposure;
	timerStep.connect("timeout",_made_a_step);
	_handle_positions();
	
func _process(delta: float) -> void:
	var NewDelta : float = delta * main.fpsTarget;

	if main.NightmareToySonicAILevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareToySonicAILevel;
			if timerChangePosition <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				if main.random_chance(SkipMovementChance):
					if Direction == Directions.LEFT:
						LVentSFX.play();
					else:
						RVentSFX.play();
					currentPosition += 1;
					_handle_positions();
		#counter
		if currentPosition >= positionsAvailable && main.PlayerPosition == "Desk" && hasShocked && !main.ntsDeskRunning && main.PlayerNotMoving:
			main.ntsDeskRunning = true;
			if Direction == Directions.LEFT:
				RunGraphics.move_child(RunGraphics.get_node("RightFoot"),0);
				RunGraphics.get_node("RightFoot").scale = Vector2(1,1);
				RunGraphics.move_child(RunGraphics.get_node("LeftFoot"),2);
				RunGraphics.scale.x = 1;
				RunGraphics.position.x = -1240;
			else:
				RunGraphics.move_child(RunGraphics.get_node("RightFoot"),2);
				RunGraphics.get_node("RightFoot").scale = Vector2(1.2,1.2);
				RunGraphics.move_child(RunGraphics.get_node("LeftFoot"),0);
				RunGraphics.scale.x = -1;
				RunGraphics.position.x = 1240;
			RunGraphics.visible = true;
			timerStep.start();
			var t : Tween = create_tween();
			if Direction == Directions.LEFT:
				t.tween_property(RunGraphics,"position:x",1240,0.5);
			else:
				t.tween_property(RunGraphics,"position:x",-1240,0.5);
			await t.finished;
			timerStep.stop();
			ventLeaveSFX.play();
			RunGraphics.visible = false;
			RunGraphics.scale.x = 1;
			RunGraphics.position.x = 0;
			timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
			jumpscareExposure = je;
			currentPosition = 0;
			main.ntsDeskRunning = false;
			_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Toy Sonic";
				jumpscare = true;
				jumpscareExposure = je;
				main.PlayerAlive = false;
				if Direction == Directions.LEFT:
					LPosition2.visible = false;
				else:
					RPosition2.visible = false;
				if main.PlayerPosition != "Office":
					if Mask.isUsingMask:
						Mask.get_node("CD_Timer").stop();
						Mask._remove();
						await Mask.MaskIsRemoved;
					officeRoomTravel._travel();
					await officeRoomTravel.doneTraveling;
				jumpscareAnimation.play("jumpscare");
				GlobalAudioManager.get_node("Sonic_Jumpscare").play();
				await jumpscareAnimation.animation_finished;
				get_tree().change_scene_to_file("res://assets/scenes/gameover.tscn");
		#special events
		if currentPosition == 1: #peeking
			if Direction == Directions.LEFT:
				if LFlashlight.is_on && !hasPeeked:
					hasPeeked = true;
					LPeekingAnimation.play("Peeking");
			else:
				if RFlashlight.is_on && !hasPeeked:
					hasPeeked = true;
					RPeekingAnimation.play("Peeking");
		if currentPosition == 2: #shocking
			if Direction == Directions.LEFT:
				if LFlashlight.is_on && !hasShocked:
					hasShocked = true;
					shockSFX.play();
			else:
				if RFlashlight.is_on && !hasShocked:
					hasShocked = true;
					shockSFX.play();
		
func _choose_path() -> void:
	if main.random_chance(50):
		Direction = Directions.LEFT;
	else:
		Direction = Directions.RIGHT;
		
func _handle_positions() -> void:
	if Direction == Directions.LEFT:
		if LFlashlight.is_on:
			LFlashlight._turn_off();
	else:
		if RFlashlight.is_on:
			RFlashlight._turn_off();
		
	match(currentPosition):
		0:
			_choose_path();
			LPosition1.visible = false;
			LPosition2.visible = false;
			RPosition1.visible = false;
			RPosition2.visible = false;
			if hasPeeked:
				hasPeeked = false;
			if hasShocked:
				hasShocked = false;
			if canAttack:
				canAttack = false;
		1:
			if Direction == Directions.LEFT:
				LPosition1.visible = true;
				LPosition2.visible = false;
				RPosition1.visible = false;
				RPosition2.visible = false;
			else:
				LPosition1.visible = false;
				LPosition2.visible = false;
				RPosition1.visible = true;
				RPosition2.visible = false;
		2:
			if Direction == Directions.LEFT:
				LPosition1.visible = false;
				LPosition2.visible = true;
				RPosition1.visible = false;
				RPosition2.visible = false;
			else:
				LPosition1.visible = false;
				LPosition2.visible = false;
				RPosition1.visible = false;
				RPosition2.visible = true;
			canAttack = true;

func _made_a_step() -> void:
	stepSfx.play();
