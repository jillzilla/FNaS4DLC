extends Node2D

signal MaskIsRemoved;

#variables
@export var scrolling: ScrollingComponent;
@export var travel: Node;

@onready var dasprite: AnimatedSprite2D = $Sprite;

@onready var cooldown_timer: Timer = $CD_Timer;

@onready var on_SFX: AudioStreamPlayer = $ON;
@onready var off_SFX: AudioStreamPlayer = $OFF;

var canUseMask: bool = false;
var isUsingMask: bool = false;
var breath: bool = false;
var PuttingMask: bool = false;

var breathTime: float;
var breathradius: float = 50;
var breathspeed: float = 2;

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
		dasprite.offset.x = breathradius * sin(breathTime);
		dasprite.offset.y = breathradius * sin(breathTime) * cos(breathTime);
	else:
		breathTime = 0;
		if dasprite.offset.x != 0:
			dasprite.offset.x = 0;
		if dasprite.offset.y != 0:
			dasprite.offset.y = 0;

func _put_on() -> void:
	if cooldown_timer.is_stopped():
		if canUseMask:
			cooldown_timer.start();
			isUsingMask = true;
			PuttingMask = true;

			on_SFX.play();

			var t: Tween = create_tween();
			t.tween_property(dasprite, "position:y", 360, 0.2).set_trans(Tween.TRANS_CUBIC);
			await t.finished;

			breath = true;
			dasprite.play("idle");

			await cooldown_timer.timeout;

			PuttingMask = false;

func _remove() -> void:
	if cooldown_timer.is_stopped():
		cooldown_timer.start();
		isUsingMask = false;
		PuttingMask = true;

		breath = false;
		dasprite.play("move");

		off_SFX.play();

		var t: Tween = create_tween();
		t.tween_property(dasprite, "position:y", -360, 0.2).set_trans(Tween.TRANS_CUBIC);
		
		await cooldown_timer.timeout;

		PuttingMask = false;
		MaskIsRemoved.emit();