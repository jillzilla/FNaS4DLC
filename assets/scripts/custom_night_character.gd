extends VBoxContainer

#variables
const REQUIREDHOLDTIME: float = 0.15;

@export var character_name: String;
@export_file_path("*.png") var character_icon_path: String;

@export var minlevel: int = main.AIMINVALUE;
@export var maxlevel: int = main.AIMAXVALUE;

var holdTime: float = 0.0;

var HoverLeft: bool = false;
var HoverRight: bool = false;

@onready var name_: Label = $Name;
@onready var ai_counter: Label = $AiLevel/Counter;
@onready var icon: TextureRect = $Icon;
@onready var ai_change_timer: Timer = $Timer_Change_AI_Level;

#functions
func _ready() -> void:
	if !character_name:
		name_.text = "";
	else:
		name_.text = character_name;
		
	if !character_icon_path:
		icon.texture = null;
	else:
		icon.texture = load(character_icon_path);
		
	_update_ai_counter();

func _process(delta: float) -> void:
	if Input.is_action_pressed("CLICK") && HoverLeft || Input.is_action_pressed("CLICK") && HoverRight:
		holdTime += delta;
		if holdTime >= REQUIREDHOLDTIME:
			if ai_change_timer.is_stopped():
				ai_change_timer.start();
	else:
		if !ai_change_timer.is_stopped():
			ai_change_timer.stop();
		holdTime = 0;
	
func _add() -> void:
	main.ai_levels[character_name] += 1;
	if main.ai_levels[character_name] > maxlevel:
		main.ai_levels[character_name] = minlevel;
	_update_ai_counter();
		
func _sub() -> void:
	main.ai_levels[character_name] -= 1;
	if main.ai_levels[character_name] < minlevel:
		main.ai_levels[character_name] = maxlevel;
	_update_ai_counter();
	
func _set_min() -> void:
	main.ai_levels[character_name] = minlevel;
	_update_ai_counter();
	
func _set_random() -> void:
	main.ai_levels[character_name] = randi_range(minlevel, maxlevel);
	_update_ai_counter();
	
func _set_max() -> void:
	main.ai_levels[character_name] = maxlevel;
	_update_ai_counter();
	
func _update_ai_counter() -> void:
	if main.ai_levels[character_name] > minlevel:
		ai_counter.text = str(main.ai_levels[character_name]).pad_zeros(2);
		modulate.a = 1;
	else:
		ai_counter.text = "X";
		modulate.a = 0.2;
		
	if main.ai_levels[character_name] == maxlevel:
		modulate = Color(1, 0, 0, modulate.a);
	else:
		modulate = Color(1, 1, 1, modulate.a);

func _on_left_pressed() -> void:
	_sub();

func _on_right_pressed() -> void:
	_add();

func _on_left_mouse_entered() -> void:
	HoverLeft = true;

func _on_right_mouse_entered() -> void:
	HoverRight = true;

func _on_left_mouse_exited() -> void:
	HoverLeft = false;

func _on_right_mouse_exited() -> void:
	HoverRight = false;

func _on_timer_change_ai_level_timeout() -> void:
	if HoverLeft:
		_sub();
	elif HoverRight:
		_add();