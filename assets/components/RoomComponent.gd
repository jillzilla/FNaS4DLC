class_name RoomComponent extends Component

signal _player_went_to_room;

#variables
const ROOMSPAWNPOSITION: Vector2 = Vector2(1040.0, 710.0);
const ROOMDESPAWNPOSITION: Vector2 = Vector2(2752.0, 710.0);
const SCROLLINGCAMERASTARTPOSITIONY: float = 1060.0;
const SCROLLINGCAMERAENDPOSITIONY: float = 360.0;

enum inputs {
	NONE,
	PRESSED,
	ENTERED,
};

@onready var buttons: Array[Node] = get_tree().get_nodes_in_group("Buttons");
@onready var rooms: Array[Node] = get_tree().get_nodes_in_group("Rooms");

@onready var camera_movement_tween: Tween = null;

@export_group("Nodes")
@export var button: Area2D = null;
@export var walk_sound: AudioStreamPlayer;
@export var room_go_to: Sprite2D;
@export var buttons_to_activate: Array[Area2D];
@export var transition: AnimationPlayer;
@export var player_component : Player_Component;
@export var scrolling_component : ScrollingComponent;
@export var flashlight_component : FlashlightComponent;

@export_group("Flags")
@export var input: Variant = inputs.NONE;
@export var camera_movement: bool = false;
@export var allow_scrolling: bool = false;
@export var allow_mask: bool = false;

#functions
func _ready() -> void:
	button.connect("input_event", _button_pressed);
	button.connect("mouse_entered", _button_mouse_entered);
	if room_go_to != null:
		room_go_to.position = ROOMDESPAWNPOSITION;

func _button_pressed(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			_go_to_room();

func _button_mouse_entered() -> void:
	if input == inputs.ENTERED:
		_go_to_room();

func _go_to_room() -> void:
	if player_component.can_move:
		player_component.can_move = false;

		for b in buttons:
			if b.input_pickable:
				b.input_pickable = false;

		for b in buttons_to_activate:
			b.input_pickable = true;

		player_component.can_scroll = false;
		player_component.flashlight = null;
		player_component.can_use_mask = false;

		walk_sound.play();

		transition.play("fade");

		await transition.animation_finished;

		transition.play_backwards("fade");

		for r in rooms:
			if r.position != ROOMDESPAWNPOSITION:
				r.position = ROOMDESPAWNPOSITION;
		
		if room_go_to != null:
			room_go_to.position = ROOMSPAWNPOSITION;

		scrolling_component._center_camera();

		if camera_movement:
			scrolling_component.camera.position.y = SCROLLINGCAMERASTARTPOSITIONY;
			if camera_movement_tween:
				camera_movement_tween.kill();
			camera_movement_tween = create_tween();
			camera_movement_tween.tween_property(scrolling_component.camera, "position:y", SCROLLINGCAMERAENDPOSITIONY, 0.5).set_trans(Tween.TRANS_CUBIC);
			await camera_movement_tween.finished;

		if allow_scrolling:
			player_component.can_scroll = true;

		if flashlight_component:
			player_component.flashlight = flashlight_component;
		
		if allow_mask:
			player_component.can_use_mask = true;

		player_component.can_move = true;
		_player_went_to_room.emit();