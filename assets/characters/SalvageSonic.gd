class_name SalvageSonic extends Node

signal moved;

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
@export var Position4 : Sprite2D;
@export var Position5 : Sprite2D;
@export var Position6 : Sprite2D;
@export var Position7 : Sprite2D;

@export_group("Mechanicals")
@export var monitor : Node2D;
@export var laugh : AudioStreamPlayer;
@export var dangersound : AudioStreamPlayer;
@export var flashlight : FlashLightComponent;
@export var officeRoomTravel : RoomTravelComponent;
@export var Mask : Node2D;
@export var jumpscareAnimation : AnimationPlayer;

var ce : float;
var je : float;

var positionsAvailable : int = 6;

var canAttack : bool = false;
var jumpscare : bool = false;
var haslaughed : bool = false;

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
			if currentPosition >= 5 && !flashlight.is_on || currentPosition < 5:
				timerChangePosition -= NewDelta * main.NightmareSalvageAiLevel;
				if timerChangePosition <= 0:
					timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
					counterExposure = ce;
					currentPosition += 1;
					_handle_positions();
					if currentPosition < positionsAvailable:
						moved.emit();
		#counter
		if currentPosition >= positionsAvailable - 1 && flashlight.is_on && main.PlayerPosition == "Hallway":
			counterExposure -= NewDelta * counterExposureLevel;
			if counterExposure <= 0:
				timerChangePosition = randf_range(minTimerChangePosition,maxTimerChangePosition);
				counterExposure = ce;
				jumpscareExposure = je;
				if !Position6.visible:
					currentPosition -= 1;
				else:
					currentPosition = 0;
				_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking && !main.nlnDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Salvage Sonic";
				jumpscare = true;
				jumpscareExposure = je;
				main.PlayerAlive = false;
				Position7.visible = false;
				if main.PlayerPosition != "Office":
					if Mask.isUsingMask:
						Mask.get_node("CD_Timer").stop();
						Mask._remove();
						await Mask.MaskIsRemoved;
					officeRoomTravel._travel();
					await officeRoomTravel.doneTraveling;
				jumpscareAnimation.play("jumpscare");
				GlobalAudioManager.get_node("Salvage_Jumpscare").play();
				await jumpscareAnimation.animation_finished;
				loading._load_scene("res://assets/scenes/gameover.tscn");
				await loading.scene_loaded;
				get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
	
func _handle_positions():
	if main.NightmareSalvageAiLevel != 0:
		monitor.visible = true;
	else:
		monitor.visible = false;
	
	match(currentPosition):
		0:
			Position1.visible = true;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = false;
			if dangersound.is_playing():
				dangersound.stop();
			if canAttack:
				canAttack = false;
			if haslaughed:
				haslaughed = false;
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
			if !haslaughed:
				laugh.play();
				haslaughed = true;
			if !dangersound.is_playing():
				dangersound.play();
			if canAttack:
				canAttack = false;
		6:
			Position1.visible = false;
			Position2.visible = false;
			Position3.visible = false;
			Position4.visible = false;
			Position5.visible = false;
			Position6.visible = false;
			Position7.visible = true;
			canAttack = true;
