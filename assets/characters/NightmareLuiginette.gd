class_name NightmareLuiginette extends Node

#variables
enum Directions {NONE,LEFT,RIGHT,HALLWAY,CEILING};
var Direction : Variant = Directions.NONE;

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
@export var leftventSprite : Sprite2D;
@export var rightventSprite : Sprite2D;
@export var hallwaySprite : Sprite2D;
@export var ceilingSprite : Sprite2D;

@export_group("Mechanicals")
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var LFlashlight : FlashLightComponent;
@export var RFlashlight : FlashLightComponent;
@export var FFlashlight : FlashLightComponent;
@export var CFlashlight : FlashLightComponent;
@export var shockSFX : AudioStreamPlayer;
@export var LVentSFX : AudioStreamPlayer2D;
@export var RVentSFX : AudioStreamPlayer2D;
@export var RunGraphics : Node2D;
@export var charAway : AnimationPlayer;
@export var jumpscareAnimation : AnimationPlayer;
@export var walkingSounds : Array[AudioStreamPlayer];

var positionsAvailable : int = 1;

var canAttack : bool = false;
var jumpscare : bool = false;
var hasShocked : bool = false;

var ce : float;
var je : float;

#functions
func _ready() -> void:
	timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
	ce = counterExposure;
	je = jumpscareExposure;
	_handle_positions();

func _process(delta: float) -> void:
	var NewDelta : float = delta * main.fpsTarget;

	if main.NightmareLuiginetteAiLevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareLuiginetteAiLevel;
			if timerChangePosition <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				if main.random_chance(SkipMovementChance):
					currentPosition += 1;
					_handle_positions();
				else:
					_switch_path();
		#counter
		if currentPosition >= positionsAvailable && hasShocked && Direction == Directions.LEFT && main.PlayerPosition == "Left_Vent" && Mask.isUsingMask || currentPosition >= positionsAvailable && hasShocked && Direction == Directions.RIGHT && main.PlayerPosition == "Right_Vent" && Mask.isUsingMask || currentPosition >= positionsAvailable && hasShocked && Direction == Directions.CEILING && CFlashlight.is_on && main.PlayerPosition == "Ceiling":
			counterExposure -= NewDelta * counterExposureLevel;
			if counterExposure <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				counterExposure = ce;
				jumpscareExposure = je;
				currentPosition = 0;
				charAway.play_backwards("fade");
				_handle_positions();
		elif currentPosition >= positionsAvailable && hasShocked && Direction == Directions.HALLWAY && main.PlayerPosition == "Desk" && !main.nlnDeskWalking:
			main.nlnDeskWalking = true;
			RunGraphics.position.x = 1240;
			RunGraphics.visible = true;
			var t : Tween = create_tween();
			t.tween_property(RunGraphics,"position:x",-1240,2.5);
			await t.finished;
			charAway.play_backwards("fade");
			RunGraphics.visible = false;
			RunGraphics.scale.x = 1;
			RunGraphics.position.x = 0;
			timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
			jumpscareExposure = je;
			currentPosition = 0;
			main.nlnDeskWalking = false;
			_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking && !main.nlnDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Luiginette";
				jumpscare = true;
				jumpscareExposure = je;
				main.PlayerAlive = false;
				leftventSprite.visible = false;
				rightventSprite.visible = false;
				hallwaySprite.visible = false;
				ceilingSprite.visible = false;
				if main.PlayerPosition != "Office":
					if Mask.isUsingMask:
						Mask.get_node("CD_Timer").stop();
						Mask._remove();
						await Mask.MaskIsRemoved;
					officeRoomTravel._travel();
					await officeRoomTravel.doneTraveling;
				jumpscareAnimation.play("jumpscare");
				GlobalAudioManager.get_node("Luigi_Jumpscare").play();
				await jumpscareAnimation.animation_finished;
				get_tree().change_scene_to_file("res://assets/scenes/gameover.tscn");
		#special events
		if currentPosition == 1 && !hasShocked: #shocking
			match(Direction):
				Directions.LEFT:
					if LFlashlight.is_on:
						shockSFX.play();
						hasShocked = true;
				Directions.RIGHT:
					if RFlashlight.is_on:
						shockSFX.play();
						hasShocked = true;
				Directions.HALLWAY:
					if FFlashlight.is_on:
						shockSFX.play();
						hasShocked = true;
				Directions.CEILING:
					if CFlashlight.is_on:
						shockSFX.play();
						hasShocked = true;

func _switch_path() -> void:
	var path : int = randi_range(1,4);
	match(path):
		1:
			Direction = Directions.LEFT;
		2:
			Direction = Directions.RIGHT;
		3:
			Direction = Directions.HALLWAY;
		4:
			Direction = Directions.CEILING;
			
func _handle_positions() -> void:
	match(Direction):
		Directions.LEFT:
			if LFlashlight.is_on:
				LFlashlight._turn_off();
		Directions.RIGHT:
			if RFlashlight.is_on:
				RFlashlight._turn_off();
		Directions.HALLWAY:
			if FFlashlight.is_on:
				FFlashlight._turn_off();
		Directions.CEILING:
			if CFlashlight.is_on:
				CFlashlight._turn_off();
				
	match(currentPosition):
		0:
			_switch_path();
			leftventSprite.visible = false;
			rightventSprite.visible = false;
			hallwaySprite.visible = false;
			ceilingSprite.visible = false;
			canAttack = false;
			hasShocked = false;
		1:
			match(Direction):
				Directions.LEFT:
					LVentSFX.play();
					leftventSprite.visible = true;
				Directions.RIGHT:
					RVentSFX.play();
					rightventSprite.visible = true;
				Directions.HALLWAY:
					walkingSounds.pick_random().play();
					hallwaySprite.visible = true;
				Directions.CEILING:
					walkingSounds.pick_random().play();
					ceilingSprite.visible = true;
			canAttack = true;
