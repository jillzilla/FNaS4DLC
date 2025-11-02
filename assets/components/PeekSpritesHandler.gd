class_name PeekSpritesHandler extends Node

#variables
@export var sprite : AnimatedSprite2D;

#functions
func _ready() -> void:
	sprite.connect("animation_finished",_peek_finished);

func _peek_finished() -> void:
	sprite.visible = false;