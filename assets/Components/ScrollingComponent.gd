class_name ScrollingComponent extends Component

#variables
@export var camera: Camera2D;

@export var scrollSpeed: float;
@export var scrollDistance: float;

@export var xResolution: int;

@onready var leftPoint: Node2D = Node2D.new();
@onready var rightPoint: Node2D = Node2D.new();

@export var player_component: Player_Component;

#functions
func _ready() -> void:
	camera.call_deferred("add_child", leftPoint);
	camera.call_deferred("add_child", rightPoint);

	leftPoint.position.x = - scrollDistance;
	rightPoint.position.x = scrollDistance;

	xResolution /= 2;

func _process(delta: float) -> void:
	var mouseX: float = camera.get_local_mouse_position().x;
	
	if player_component.is_alive && player_component.can_scroll:
		if camera.position.x > camera.limit_left + xResolution:
			if mouseX <= leftPoint.position.x: camera.move_local_x(-scrollSpeed * delta);
		if camera.position.x < camera.limit_right - xResolution:
			if mouseX >= rightPoint.position.x: camera.move_local_x(scrollSpeed * delta);
	
	camera.position.x = clamp(camera.position.x, camera.limit_left + xResolution, camera.limit_right - xResolution);
 
func _center_camera() -> void:
	@warning_ignore("integer_division")
	camera.position.x = camera.limit_right / 2;