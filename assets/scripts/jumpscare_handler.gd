extends Node2D

#variables
@export var animation: AnimationPlayer;
@export var loading: Control;
@export var go_to_gameover: bool = true;

#functions
func _ready() -> void:
	animation.connect("animation_finished", _jumpscare_animation_finished);

func _jumpscare_animation_finished(anim_name: String) -> void:
	if anim_name == "jumpscare":
		if go_to_gameover:
			GlobalAudioManager.get_node("Ambience").stop();
			loading._load_scene("res://assets/scenes/gameover.tscn");
		else:
			hide();
