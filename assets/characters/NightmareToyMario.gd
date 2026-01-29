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
@export var shockSFX : AudioStreamPlayer;
@export var peekingAnimation : AnimationPlayer;

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
