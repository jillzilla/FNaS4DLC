class_name FlashLightComponent extends Node

#variables
@export var tailsdoll : TailsDoll;
@export var BT : NightmareBT;
@export var spriteAsFlashlight : Sprite2D;
@export var scrolling : ScrollingComponent;
@export var flashlightSFX : AudioStreamPlayer;
@export var travel : RoomTravelComponent;
@export var enabled : bool = false;
@export var mask : Node2D;
@onready var tween_tailsdoll : Tween = null;

var is_on : bool = false;

#functions
func _turn_on() -> void:
	is_on = true;
	
	spriteAsFlashlight.visible = false;
	flashlightSFX.play();
	
	if BT.canAttack && main.PlayerPosition == "Left_Vent":
		BT.flashCounter += 1;
		
	if tailsdoll.currentPosition == 1:
		match(tailsdoll.Direction):
			tailsdoll.Directions.LEFT:
				if main.PlayerPosition == "Left_Vent":
					_get_rid_of_tails(tailsdoll.position_left);
			tailsdoll.Directions.RIGHT:
				if main.PlayerPosition == "Right_Vent":
					_get_rid_of_tails(tailsdoll.position_right);
			tailsdoll.Directions.CEILING:
				if main.PlayerPosition == "Ceiling":
					_get_rid_of_tails(tailsdoll.position_up);
						
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
	
func _get_rid_of_tails(sprite : Sprite2D) -> void:
	tailsdoll.currentPosition = 0;
	if tween_tailsdoll:
		tween_tailsdoll.kill();
	tween_tailsdoll = create_tween();
	tween_tailsdoll.tween_property(sprite,"modulate:a",0,0.5);
	if tailsdoll.effect.is_playing():
		tailsdoll.effect.speed_scale = 1.5;
		tailsdoll.effect.play_backwards("ATTACK");
	else:
		tailsdoll.effect.stop();
	tween_tailsdoll.connect("finished", _tails_stops_disappearing);

func _tails_stops_disappearing() -> void:
	tailsdoll._handle_positions();
	tailsdoll.position_left.modulate.a = 1;
	tailsdoll.position_right.modulate.a = 1;
	tailsdoll.position_up.modulate.a = 1;
