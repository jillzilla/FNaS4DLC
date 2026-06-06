class_name ButtonComponent extends Node

#functions
func _ready() -> void:
	get_parent().connect("mouse_entered",_make_sound);
	get_parent().connect("mouse_exited",_make_sound);

func _make_sound() -> void:
	GlobalAudioManager.get_node("Select").play();
