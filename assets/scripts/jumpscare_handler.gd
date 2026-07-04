extends Node2D

#variables
@export var loading: Control;
@export var go_to_gameover: bool = true;

@onready var animation: AnimationPlayer = $AnimationPlayer;

#functions
func _ready() -> void:
	animation.connect("animation_finished", _jumpscare_animation_finished);

func _jumpscare_animation_finished(anim_name: String) -> void:
	if anim_name == "jumpscare":
		if go_to_gameover:
			loading._load_scene("uid://dnhbquuqsi7p1");
		else:
			hide();