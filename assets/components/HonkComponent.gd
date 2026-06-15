class_name HonkComponent extends Component

#variables
@export var button : Area2D;
@export var sound : AudioStreamPlayer2D;

#functions
func _ready() -> void:
    button.connect("input_event",_button_pressed);

func _button_pressed(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
            sound.play();