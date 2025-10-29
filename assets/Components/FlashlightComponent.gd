class_name FlashLightComponent extends Node

#variables
@export var spriteAsFlashlight : Sprite2D;
@export var scrolling : ScrollingComponent;
@export var travel : RoomTravelComponent;
@export var enabled : bool = false;

#functions
func _process(_delta: float) -> void:
	if scrolling.get_parent().position.y == travel.camPosYEffectEnd:
		if enabled:
			if Input.is_action_just_pressed("FLASHLIGHT"):
				spriteAsFlashlight.visible = false;

			elif Input.is_action_just_released("FLASHLIGHT"):
				spriteAsFlashlight.visible = true;
		else:
			if !spriteAsFlashlight.visible:
				spriteAsFlashlight.visible = true;
