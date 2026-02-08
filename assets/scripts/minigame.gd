extends Node

#variables
@export var Light : PointLight2D;
@export var flashSound : AudioStreamPlayer;

#functions
func _ready() -> void:
	DiscordManager._update_details("Fun with Plushnic & Plushtails");
	DiscordManager._update_state("");

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("FLASHLIGHT"):
		Light.visible = true;
		flashSound.play();
	if Input.is_action_just_released("FLASHLIGHT"):
		Light.visible = false;
		flashSound.stop();
		
func _process(_delta: float) -> void:
	if Light.position != get_viewport().get_mouse_position():
		Light.position = get_viewport().get_mouse_position();
