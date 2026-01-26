extends Node2D

signal MaskIsRemoved;

#variables
@export var scrolling : ScrollingComponent;
@export var travel : RoomTravelComponent;

var canUseMask : bool = false;
var isUsingMask : bool = false;
var breath : bool = false;
var PuttingMask : bool = false;

var breathTime : float;
var breathradius : float = 50;
var breathspeed : float = 2;

#functions
func _process(_delta: float) -> void:
	if main.PlayerAlive:
		if Input.is_action_just_pressed("MASK"):
			if !isUsingMask:
				_put_on();
			else:
				_remove();

func _physics_process(delta: float) -> void:
	if breath:
		breathTime += delta * breathspeed;
		get_node("Sprite").offset.x = breathradius * sin(breathTime);
		get_node("Sprite").offset.y = breathradius * sin(breathTime) * cos(breathTime);
	else:
		breathTime = 0;
		if get_node("Sprite").offset.x != 0:
			get_node("Sprite").offset.x = 0;
		if get_node("Sprite").offset.y != 0:
			get_node("Sprite").offset.y = 0;

func _put_on() -> void:
	if get_node("CD_Timer").is_stopped():
		if canUseMask:
			get_node("CD_Timer").start();
			isUsingMask = true;
			PuttingMask = true;

			get_node("ON").play();

			var t : Tween = create_tween();
			t.tween_property(get_node("Sprite"),"position:y",360,0.2).set_trans(Tween.TRANS_CUBIC);
			await t.finished;

			breath = true;
			get_node("Sprite").play("idle");

			await get_node("CD_Timer").timeout;

			PuttingMask = false;

func _remove() -> void:
	if get_node("CD_Timer").is_stopped():
		get_node("CD_Timer").start();
		isUsingMask = false;
		PuttingMask = true;

		breath = false;
		get_node("Sprite").play("move");

		get_node("OFF").play();

		var t : Tween = create_tween();
		t.tween_property(get_node("Sprite"),"position:y",-360,0.2).set_trans(Tween.TRANS_CUBIC);
		
		await get_node("CD_Timer").timeout;

		PuttingMask = false;
		MaskIsRemoved.emit();
