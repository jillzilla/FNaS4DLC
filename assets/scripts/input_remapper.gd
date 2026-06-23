extends Button

#variables
@export var action: String = "";
var is_remapping: bool = true;

#functions
func _init() -> void:
    toggle_mode = true;

func _ready() -> void:
    set_process_unhandled_input(false);

func _toggled(toggled_on: bool) -> void:
    set_process_unhandled_input(toggled_on);
    if toggled_on:
        text = "...";
        is_remapping = true;

func _process(_delta: float) -> void:
    if is_remapping && !has_focus():
        button_pressed = false;
        is_remapping = false;
        _update_text();

func _unhandled_input(event: InputEvent) -> void:
    if event.pressed:
        main.keys[action] = event.keycode;
        button_pressed = false;
        is_remapping = false;
        release_focus();
        _update_text();

func _update_text() -> void:
    var input_key: InputEvent = InputEventKey.new();
    input_key.keycode = main.keys[action];
    text = input_key.as_text();