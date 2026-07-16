class_name FlashlightComponent extends Component

signal flashlight_is_on;
signal flashlight_is_off;

#variables
@export var player_component: Player_Component = null;
@export var sound: AudioStreamPlayer = null;
@export var darkness_sprite: Sprite2D = null;

var is_flashlight_on: bool = false;
var disable: bool = false;

#functions
func _process(_delta: float) -> void:
    if player_component.flashlight == self && player_component.is_alive && !disable && player_component.flashbattery > 0:
        if Input.is_action_pressed("FLASHLIGHT"):
            _flashlight_on();
    if player_component.flashlight == null || !Input.is_action_pressed("FLASHLIGHT") || !player_component.is_alive || disable:
        _flashlight_off();

func _flashlight_on() -> void:
    if !is_flashlight_on:
        if main.save_data_file.limited_flashlight:
            if player_component.flashlight_battery_drain_timer.is_stopped():
                player_component.flashlight_battery_drain_timer.start();
            else:
                player_component.flashlight_battery_drain_timer.paused = false;
        is_flashlight_on = true;
        darkness_sprite.hide();
        sound.play();
        flashlight_is_on.emit();

func _flashlight_off() -> void:
    if is_flashlight_on:
        is_flashlight_on = false;
        darkness_sprite.show();
        sound.stop();
        player_component.flashlight_battery_drain_timer.paused = true;
        flashlight_is_off.emit();