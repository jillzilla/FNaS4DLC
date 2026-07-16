class_name ButtonComponent extends Component

#variables
@onready var button: Button = get_parent();

#functions
func _ready() -> void:
    button.connect("mouse_entered", _make_sound);
    button.connect("mouse_exited", _make_sound);

func _make_sound() -> void:
    GlobalAudioManager.get_node("Select").play();