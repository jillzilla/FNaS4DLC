class_name ScrollingComponent extends Node

#variables
@export var disable : bool;
@export var camera : Camera2D;

@export var scrollSpeed : float;
@export var scrollDistance : float;
@export var xResolution : int;

@onready var leftPoint : Node2D = Node2D.new();
@onready var rightPoint : Node2D = Node2D.new();

#functions
func _ready() -> void:
	xResolution /= 2;

	camera.call_deferred("add_child",leftPoint);
	camera.call_deferred("add_child",rightPoint);

	leftPoint.position.x = -scrollDistance;
	rightPoint.position.x = scrollDistance;

func _process(delta: float) -> void:
	var mouseX : float = camera.get_local_mouse_position().x;

	if main.PlayerAlive:
		if !disable:
			if camera.position.x > camera.limit_left + xResolution:
				if mouseX <= leftPoint.position.x:
					camera.position.x -= scrollSpeed * (delta * main.fpsTarget);

			if camera.position.x < camera.limit_right - xResolution:
				if mouseX >= rightPoint.position.x:
					camera.position.x += scrollSpeed * (delta * main.fpsTarget);

	camera.position.x = clamp(camera.position.x,camera.limit_left + xResolution,camera.limit_right - xResolution);

func _center_camera() -> void:
	@warning_ignore("integer_division")
	camera.position.x = camera.limit_right / 2;