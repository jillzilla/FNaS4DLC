class_name FlashlightComponent extends Component

signal flashlight_is_on;
signal flashlight_is_off;

#variables
@export var player_component : Player_Component;
@export var sound : AudioStreamPlayer;
@export var darkness_sprite : Sprite2D;

var is_flashlight_on : bool = false;

#functions
func _process(_delta: float) -> void:
    if player_component.flashlight == self:
        if Input.is_action_just_pressed("FLASHLIGHT"):
            _flashlight_on();
    if player_component.flashlight == null || !Input.is_action_pressed("FLASHLIGHT"):
        _flashlight_off();

func _flashlight_on() -> void:
    is_flashlight_on = true;
    darkness_sprite.hide();
    sound.play();
    flashlight_is_on.emit();

func _flashlight_off() -> void:
    if is_flashlight_on:
        is_flashlight_on = false;
        darkness_sprite.show();
        sound.stop();
        flashlight_is_off.emit();