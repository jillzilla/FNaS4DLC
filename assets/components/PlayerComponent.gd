class_name Player_Component extends Component

#variables
@export var is_alive: bool = true;
@export var can_scroll: bool = true;
@export var can_use_mask: bool = false;
@export var can_move: bool = true;
@export var flashlight_battery_drain_timer: Timer = null;
@export var flashlight: FlashlightComponent = null;
@export var flashlight_battery_counter: Label = null;
@export var endless_mode_points_counter: Label = null;
@export var endless_mode_hours_counter: Label = null;

var direction: String = "Office";

var is_moving: bool = false;

var characters_walking_on_desk: Array[DeskMechanicComponent] = [];

var flashbattery: int = 100;

var endless_mode_points: int = 0;
var endless_mode_hours: int = 0;

#functions
func _ready() -> void:
    flashlight_battery_drain_timer.connect("timeout", _flashlight_timer_timeout);

    if main.save_data_file.limited_flashlight:
        flashlight_battery_counter.show();
    
    if main.nightcounter == main.ENDLESSID:
        endless_mode_points_counter.show();
        endless_mode_hours_counter.show();

func _flashlight_timer_timeout() -> void:
    flashbattery -= 1;
    if flashbattery <= 0:
        flashbattery = 0;
        flashlight_battery_drain_timer.stop();
        if flashlight != null:
            if flashlight.is_flashlight_on:
                flashlight._flashlight_off();
    flashlight_battery_counter.text = "Power Left: " + str(flashbattery) + "%";

func _add_points_endless_mode(a: int) -> void:
    if main.nightcounter == main.ENDLESSID:
        endless_mode_points += a;
        if endless_mode_points > 999999:
            endless_mode_points = 999999;
        if endless_mode_points > main.save_data_file.endless_mode_highscore_score:
            main.save_data_file.endless_mode_highscore_score = endless_mode_points;
            main._save();
        _update_endless_mode_output();

func _add_hours_endless_mode(a: int) -> void:
    if main.nightcounter == main.ENDLESSID:
        endless_mode_hours += a;
        if endless_mode_hours > 999:
            endless_mode_hours = 999;
        if endless_mode_hours > main.save_data_file.endless_mode_highscore_hours:
            main.save_data_file.endless_mode_highscore_hours = endless_mode_hours;
            main._save();
        if endless_mode_hours >= 24:
            if !main.save_data_file.endless_mode_completed:
                RewardUnlockPopup.add_to_queue("Red Star");
                RewardUnlockPopup.showcase();
                main.save_data_file.endless_mode_completed = true;
                main._save();
        _update_endless_mode_output();

func _update_endless_mode_output() -> void:
    DiscordManager._update_state("Score: " + str(endless_mode_points).pad_zeros(6) + " || " + "Hours: " + str(endless_mode_hours).pad_zeros(3));
    endless_mode_points_counter.text = "Score: " + str(endless_mode_points).pad_zeros(6);
    endless_mode_hours_counter.text = "Hours: " + str(endless_mode_hours).pad_zeros(3);