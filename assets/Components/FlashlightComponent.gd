class_name FlashLightComponent extends Node

#variables
@export var BT : NightmareBT;
@export var spriteAsFlashlight : Sprite2D;
@export var scrolling : ScrollingComponent;
@export var flashlightSFX : AudioStreamPlayer;
@export var travel : RoomTravelComponent;
@export var enabled : bool = false;
@export var mask : Node2D;
var is_on : bool = false;

#functions
func _turn_on() -> void:
	is_on = true;
	spriteAsFlashlight.visible = false;
	flashlightSFX.play();
	if BT:
		if BT.canAttack && main.PlayerPosition == "Left_Vent":
			BT.flashCounter += 1;
	
func _turn_off() -> void:
	if is_on:
		is_on = false;
		spriteAsFlashlight.visible = true;
		flashlightSFX.stop();

func _process(_delta: float) -> void:
	if enabled && main.PlayerAlive && !mask.isUsingMask && !main.isBTInOffice:
		if Input.is_action_just_pressed("FLASHLIGHT"):
			_turn_on();
		elif !Input.is_action_pressed("FLASHLIGHT"):
			_turn_off();
	else:
		if is_on:
			_turn_off();
