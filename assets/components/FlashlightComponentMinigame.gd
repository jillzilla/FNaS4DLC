class_name FlashlightComponentMinigame extends Node

#i was too lazy to make the other compatible with this, sorry.

@export var light_source : PointLight2D;
@export var power_label : Label;
@export var power_timer_drain : Timer;
@export var sound : AudioStreamPlayer;

var is_on : bool = false;
var power : int = 75;

func _ready() -> void:
	power_timer_drain.connect("timeout", _timeout_timer_power_drain);

func _process(_delta: float) -> void:
	if light_source.position != get_viewport().get_mouse_position():
		light_source.position = get_viewport().get_mouse_position();
		
	if !Input.is_action_pressed("FLASHLIGHT") && is_on:
		_turn_off();
		
	power_label.text = "Power Left: " + str(power) + "%";

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("FLASHLIGHT") && power > 0:
		sound.play();
		if power_timer_drain.is_stopped():
			power -= 1;
			power_timer_drain.start();
		else:
			power_timer_drain.paused = false;
		light_source.show();
		is_on = true;

func _timeout_timer_power_drain() -> void:
	power -= 1;
	if power <= 0 && is_on:
		_turn_off();

func _turn_off() -> void:
	sound.stop();
	light_source.hide();
	power_timer_drain.paused = true;
	is_on = false;
