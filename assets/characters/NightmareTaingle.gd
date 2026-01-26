class_name NightmareTaingle extends Node

#variables
@export_group("Status")
@export var currentPosition : int = 0;
@export var timerChangePosition : float = 5000;
@export var positionChangingRate : float = 75;
@export var counterExposureLevel : float = 40;
@export var counterExposure : float = 2500;
@export var jumpscareExposure : float = 1000;

@export_group("Sprites")
@export var Position1 : Sprite2D;
@export var Position2 : Sprite2D;
@export var Position3 : Sprite2D;
@export var Position4 : Sprite2D;

@export_group("Mechanicals")
@export var flashlight : FlashLightComponent;

var cp : float;
var ce : float;

var positionsAvailable : int = 4;

#functions
func _ready() -> void:
    cp = timerChangePosition;
    ce = counterExposure;

    _handle_positions();

func _process(delta: float) -> void:
    var NewDelta : float = delta * main.fpsTarget;

    if currentPosition > 0 && !flashlight.spriteAsFlashlight.visible:
        counterExposure -= NewDelta * counterExposureLevel;
        if counterExposure <= 0:
            counterExposure = ce;
            currentPosition -= 1;
            _handle_positions();

    if currentPosition < positionsAvailable:
        if currentPosition > 0 && flashlight.spriteAsFlashlight.visible || currentPosition == 0:
            timerChangePosition -= NewDelta * main.NightmareTaingleAILevel;
            if timerChangePosition <= 0:
                timerChangePosition = cp;
                if main.random_chance(positionChangingRate):
                    currentPosition += 1;
                    _handle_positions();

func _handle_positions() -> void:
    match(currentPosition):
        0:
            Position1.visible = false;
            Position2.visible = false;
            Position3.visible = false;
            Position4.visible = false;
        1:
            Position1.visible = true;
            Position2.visible = false;
            Position3.visible = false;
            Position4.visible = false;
        2:
            Position1.visible = false;
            Position2.visible = true;
            Position3.visible = false;
            Position4.visible = false;
        3:
            Position1.visible = false;
            Position2.visible = false;
            Position3.visible = true;
            Position4.visible = false;
        4:
            Position1.visible = false;
            Position2.visible = false;
            Position3.visible = false;
            Position4.visible = true;