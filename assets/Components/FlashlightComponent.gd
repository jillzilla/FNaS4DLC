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
	flashlightSFX.play();
	spriteAsFlashlight.visible = false;
	
	if BT:
		if BT.canAttack && main.PlayerPosition == "Left_Vent":
			BT.flashCounter += 1;
	
	is_on = true;
	
func _turn_off() -> void:
	flashlightSFX.stop();
	spriteAsFlashlight.visible = true;
	is_on = false;

func _process(_delta: float) -> void:
	if enabled && main.PlayerAlive && !mask.isUsingMask:
		if Input.is_action_just_pressed("FLASHLIGHT"):
			_turn_on();

		elif Input.is_action_just_released("FLASHLIGHT"):
			_turn_off();
	else:
		if is_on:
			_turn_off();
