class_name NightmareToyYoshi extends Node

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

@export_group("Mechanicals")
@export var debug : bool = false;
@export var flashlight : FlashLightComponent;
@export var Mask : Node2D;
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

	if main.NightmareToyYoshiAILevel != 0 && !jumpscare && main.PlayerAlive:
		#movement
		if currentPosition < positionsAvailable:
			timerChangePosition -= NewDelta * main.NightmareToyYoshiAILevel;
			if timerChangePosition <= 0:
				timerChangePosition = cp;
				if main.random_chance(positionChangingRate):
					currentPosition += 1;
					_handle_positions();
					
		#counter
		if currentPosition >= positionsAvailable:
			if Mask.isUsingMask && hasShocked:
				counterExposure -= NewDelta * counterExposureLevel;
				if counterExposure <= 0:
					timerChangePosition = cp;
					counterExposure = ce;
					jumpscareExposure = je;
					currentPosition = 0;
					_handle_positions();
					
		#special events
		if currentPosition == 1: #peeking
			if flashlight.is_on && !hasPeeked:
				hasPeeked = true;
				peekingAnimation.play("Peeking");
				_debugger();
				
		if currentPosition == 3 && Position3.visible: #shocking
			if flashlight.is_on && !hasShocked:
				hasShocked = true;
				shockSFX.play();
				_debugger();

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
			
	_debugger();

func _debugger() -> void:
	if debug:
		print(">> Nightmare Yoshi");
		print("Current Position: " + str(currentPosition));
		print("Timer Change Position: " + str(timerChangePosition));
		print("Counter Exposure: " + str(counterExposure));
		print("Jumpscare Exposure: " + str(jumpscareExposure));
		print("Can Attack: " + str(canAttack));
		print("Jumpscare: " + str(jumpscare));
		print("Has Peeked: " + str(hasPeeked));
		print("Has Shocked: " + str(hasShocked));
