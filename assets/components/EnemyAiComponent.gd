class_name EnemyAIComponent extends Node

#variables
@export var AILevel : int = 0;
@export var codeName : String;

enum Directions {UNDECIDED,LEFTVENT,RIGHTVENT,HALLWAY,CEILING};
enum CounterMechanics {NONE,DESK,MASK,FLASHLIGHT,MASK_DESK,ALL_IN_ONE};

@export var canComeFromLeftVent : bool = false;
@export var canComeFromRightVent : bool = false;
@export var canComeFromCeiling : bool = false;
@export var canComeFromHallway : bool = false;

@export var LeftVentPath : Array[Node2D];
@export var RightVentPath : Array[Node2D];
@export var CeilingPath : Array[Node2D];
@export var HallwayPath : Array[Node2D];

@export var CounterMechanicLeftVent : Variant = CounterMechanics.NONE;
@export var CounterMechanicRightVent : Variant = CounterMechanics.NONE;
@export var CounterMechanicCeiling : Variant = CounterMechanics.NONE;
@export var CounterMechanicHallway : Variant = CounterMechanics.NONE;

@export var flashlightLeftVent : FlashLightComponent;
@export var flashlightRightVent : FlashLightComponent;
@export var flashlightCeiling : FlashLightComponent;
@export var flashlightHallway : FlashLightComponent;

@export var shockSFX : AudioStreamPlayer;

var tipmin : float = 5000;
var tipmax : float = 8000;

var knkmin : float = 200;
var knkmax : float = 300;

var expmin : float = 400;
var expmax : float = 800;

var path : int = -1; #not in map
var pathSprites : Array;
var pathmax : int;

var flashlighttouse : FlashLightComponent;

var choosedDirection : Variant = Directions.UNDECIDED;
var timerIncreasePath : float = randf_range(tipmin,tipmax);
var knockback : float = randf_range(knkmin,knkmax);
var exposure : float = randf_range(expmin,expmax);

var kill : bool = false;
var specialEvent : bool = false;

#functions
func _ready() -> void:
	if AILevel != 0:
		_choose_direction();

func _choose_direction() -> void:
	choosedDirection = Directions.UNDECIDED;
	
	var dirSelector : Array[Variant] = [];

	if canComeFromLeftVent:
		dirSelector.append(Directions.LEFTVENT);

	if canComeFromRightVent:
		dirSelector.append(Directions.RIGHTVENT);

	if canComeFromCeiling:
		dirSelector.append(Directions.HALLWAY);

	if canComeFromHallway:
		dirSelector.append(Directions.CEILING);
	
	choosedDirection = randi_range(dirSelector[0],dirSelector[dirSelector.size() - 1]);

	var paths : Array = [LeftVentPath,RightVentPath,HallwayPath,CeilingPath];

	match(choosedDirection):
		Directions.LEFTVENT:
			pathmax = paths[0].size() - 1;
			pathSprites = paths[0];
			flashlighttouse = flashlightLeftVent;
		Directions.RIGHTVENT:
			pathmax = paths[1].size() - 1;
			pathSprites = paths[1];
			flashlighttouse = flashlightRightVent;
		Directions.HALLWAY:
			pathmax = paths[2].size() - 1;
			pathSprites = paths[2];
			flashlighttouse = flashlightHallway;
		Directions.CEILING:
			pathmax = paths[3].size() - 1;
			pathSprites = paths[3];
			flashlighttouse = flashlightCeiling;

func _process(delta: float) -> void:
	if AILevel != 0:
		if choosedDirection != Directions.UNDECIDED:
			if path != pathmax:
				timerIncreasePath -= AILevel * delta * main.fpsTarget;

				if timerIncreasePath <= 0 && path < pathmax:

					path += 1;

					if path > 0:
						pathSprites[path - 1].visible = false;

					pathSprites[path].visible = true;

					specialEvent = false;

					if !flashlighttouse.spriteAsFlashlight.visible:
						flashlighttouse.flashlightSFX.stop();
						flashlighttouse.spriteAsFlashlight.visible = true;

					timerIncreasePath = randf_range(tipmin,tipmax);
			
			elif path >= pathmax:
				if exposure > 0:
					exposure -= AILevel * delta * main.fpsTarget;

				elif exposure <= 0:
					if !kill:
						kill = true;
			
			if !flashlighttouse.spriteAsFlashlight.visible && path > -1:
				if pathSprites[path].name == codeName + "_" + "Peek" && !specialEvent:
					print("Peek");
					pathSprites[path].play();
					specialEvent = true;

				if pathSprites[path].name == codeName + "_" + "Attack" && !specialEvent:
					print("BOO!");
					shockSFX.play();
					specialEvent = true;