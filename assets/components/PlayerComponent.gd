class_name Player_Component extends Component

#variables
@export var is_alive: bool = true;
@export var can_scroll: bool = true;
@export var can_use_mask: bool = false;
@export var can_move: bool = true;
@export var flashlight_battery_drain_timer: Timer = null;
@export var flashlight: FlashlightComponent = null;
@export var flashlight_battery_counter: Label = null;

var direction: String = "Office";

var is_moving: bool = false;

var characters_walking_on_desk: Array[DeskMechanicComponent] = [];

var flashbattery: int = 100;

#functions
func _ready() -> void:
    flashlight_battery_drain_timer.connect("timeout", _flashlight_timer_timeout);

    if main.save_data_file.limited_flashlight:
        flashlight_battery_counter.show();

func _flashlight_timer_timeout() -> void:
    flashbattery -= 1;
    if flashbattery <= 0:
        flashbattery = 0;
        flashlight_battery_drain_timer.stop();
        if flashlight != null:
            if flashlight.is_flashlight_on:
                flashlight._flashlight_off();
    flashlight_battery_counter.text = "Power Left: " + str(flashbattery) + "%";