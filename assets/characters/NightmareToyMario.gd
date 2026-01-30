class_name NightmareToyMario extends Node

#variables
enum PupilsStates {DEFAULT,ON,OFF};
var PupilsState : Variant = PupilsStates.DEFAULT;

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
@export var Position1Pupils : Sprite2D;
@export var Position2 : Sprite2D;
@export var Position2Pupils : Sprite2D;
@export var Position3 : Sprite2D;
@export var Position3Pupils : Sprite2D;

@export_group("Mechanicals")
@export var debug : bool = false;
@export var flashlight : FlashLightComponent;
@export var ventSFX : AudioStreamPlayer2D;
@export var ventLSFX : AudioStreamPlayer;
@export var shockSFX : AudioStreamPlayer;
@export var Mask : Node2D;
@export var peekingAnimation : AnimationPlayer;
@export var jumpscareAnimation : AnimationPlayer;
@export var officeRoomTravel : RoomTravelComponent;
@export var RunGraphics : Node2D;
@export var RunAnimation : AnimationPlayer;
@export var timerStep : Timer;
@export var stepSfx : AudioStreamPlayer2D;

var cp : float;
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
	cp = timerChangePosition;
	ce = counterExposure;
	je = jumpscareExposure;
	timerStep.connect("timeout",_made_a_step);
	#character setup
	_handle_positions();

func _process(delta: float) -> void:
	var NewDelta : float = delta * main.fpsTarget;

	if main.NightmareToyMarioAILevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareToyMarioAILevel;
			if timerChangePosition <= 0:
				timerChangePosition = cp;
				if main.random_chance(positionChangingRate):
					ventSFX.play();
					currentPosition += 1;
					_handle_positions();
		#counter
		if currentPosition >= positionsAvailable && hasShocked:
			if PupilsState == PupilsStates.ON:
				if main.PlayerPosition == "Right_Vent" && Mask.isUsingMask:
					counterExposure -= NewDelta * counterExposureLevel;
					if counterExposure <= 0:
						timerChangePosition = cp;
						counterExposure = ce;
						jumpscareExposure = je;
						ventLSFX.play();
						currentPosition = 0;
						_handle_positions();
			else:
				if main.PlayerPosition == "Desk" && !main.ntmDeskWalking:
					main.ntmDeskWalking = true;
					RunGraphics.position.x = 1240;
					RunGraphics.visible = true;
					timerStep.start();
					var t : Tween = create_tween();
					t.tween_property(RunGraphics,"position:x",-1240,3);
					await t.finished;
					timerStep.stop();
					ventLSFX.play();
					RunGraphics.visible = false;
					RunGraphics.scale.x = 1;
					RunGraphics.position.x = 0;
					timerChangePosition = cp;
					jumpscareExposure = je;
					currentPosition = 0;
					main.ntmDeskWalking = false;
					_handle_positions();
		#jumpscare
		elif canAttack && main.PlayerNotMoving && !Mask.PuttingMask && !main.ntsDeskRunning && !main.ntmDeskWalking:
			jumpscareExposure -= NewDelta * jumpscareExposureLevel;
			if jumpscareExposure <= 0:
				main.killedBy = "Nightmare Toy Mario";
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
				GlobalAudioManager.get_node("Mario_Jumpscare").play();
				await jumpscareAnimation.animation_finished;
				_debugger();
				get_tree().change_scene_to_file("res://assets/scenes/gameover.tscn");
		#special events
		if currentPosition == 1: #peeking
			if flashlight.is_on && !hasPeeked:
				hasPeeked = true;
				peekingAnimation.play("Peeking");
				_debugger();
		if currentPosition == 3: #shocking
			if flashlight.is_on && !hasShocked:
				hasShocked = true;
				shockSFX.play();
				_debugger();

func _choose_pupils_state() -> void:
	if main.random_chance(60):
		PupilsState = PupilsStates.ON;
	else:
		PupilsState = PupilsStates.OFF;
	
	if PupilsState == PupilsStates.ON:
		Position1Pupils.visible = true;
		Position2Pupils.visible = true;
		Position3Pupils.visible = true;
	else:
		Position1Pupils.visible = false;
		Position2Pupils.visible = false;
		Position3Pupils.visible = false;

func _handle_positions() -> void:
	if flashlight.is_on:
		flashlight._turn_off();
	
	match(currentPosition):
		0:
			_choose_pupils_state();
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
			
	_debugger();

func _made_a_step() -> void:
	stepSfx.play();

func _debugger() -> void:
	if debug:
		print(">> Nightmare Toy Mario");
		print("Pupils: " + str(PupilsState));
		print("Current Position: " + str(currentPosition));
		print("Timer Change Position: " + str(timerChangePosition));
		print("Jumpscare Exposure: " + str(jumpscareExposure));
		print("Can Attack: " + str(canAttack));
		print("Jumpscare: " + str(jumpscare));
		print("Has Peeked: " + str(hasPeeked));
		print("Has Shocked: " + str(hasShocked));
