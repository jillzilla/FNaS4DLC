class_name FlashLightComponent extends Node

#variables
@export var spriteAsFlashlight : Sprite2D;
@export var scrolling : ScrollingComponent;
@export var flashlightSFX : AudioStreamPlayer;
@export var travel : RoomTravelComponent;
@export var enabled : bool = false;

#functions
func _process(_delta: float) -> void:
	if enabled && main.PlayerAlive:
		if Input.is_action_just_pressed("FLASHLIGHT"):
			flashlightSFX.play();
			spriteAsFlashlight.visible = false;

		elif Input.is_action_just_released("FLASHLIGHT"):
			flashlightSFX.stop();
			spriteAsFlashlight.visible = true;
	else:
		if !spriteAsFlashlight.visible:
			flashlightSFX.stop();
			spriteAsFlashlight.visible = true;