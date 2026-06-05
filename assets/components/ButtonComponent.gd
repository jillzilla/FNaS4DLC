class_name ButtonComponent extends Node

#functions
func _ready() -> void:
	get_parent().connect("mouse_entered",_button_mouse_entered);
	get_parent().connect("mouse_exited",_button_mouse_exited);

func _button_mouse_entered() -> void:
	GlobalAudioManager.get_node("Select").play();

func _button_mouse_exited() -> void:
	GlobalAudioManager.get_node("Select").play();
