class_name ButtonComponent extends Node

#variables
@export var parent : Button;

#functions
func _ready() -> void:
	parent.connect("mouse_entered",_button_mouse_entered);
	parent.connect("mouse_exited",_button_mouse_exited);

func _button_mouse_entered() -> void:
	GlobalAudioManager.get_node("Select").play();

func _button_mouse_exited() -> void:
	GlobalAudioManager.get_node("Select").play();
