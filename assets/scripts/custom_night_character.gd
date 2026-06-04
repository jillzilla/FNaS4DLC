extends VBoxContainer

#variables
@export var charName : String;
@export var iconPath : String;
@export_range(0,9) var charID : int = 0;

var holdTime : float = 0.0;
const requiredHoldTime : float = 0.15;

@export var minlevel : int = 0;
@export var maxlevel : int = 25;

var HoverLeft : bool = false;
var HoverRight : bool = false;

#functions
func _ready() -> void:
	if !charName:
		get_node("Name").text = "";
	else:
		get_node("Name").text = charName;
		
	if !iconPath:
		get_node("Icon").texture = null;
	else:
		get_node("Icon").texture = load(iconPath);
	
	_update_ai_counter();

func _process(delta: float) -> void:
	if Input.is_action_pressed("CLICK") && HoverLeft || Input.is_action_pressed("CLICK") && HoverRight:
		holdTime += delta;
		if holdTime >= requiredHoldTime:
			if get_node("Timer_Change_AI_Level").is_stopped():
				get_node("Timer_Change_AI_Level").start();
	else:
		if !get_node("Timer_Change_AI_Level").is_stopped():
			get_node("Timer_Change_AI_Level").stop();
		holdTime = 0;
	
func _add() -> void:
	main.aiLevelsAsArrays[charID] += 1;
	if main.aiLevelsAsArrays[charID] > maxlevel:
		main.aiLevelsAsArrays[charID] = minlevel;
	_update_ai_counter();
		
func _sub() -> void:
	main.aiLevelsAsArrays[charID] -= 1;
	if main.aiLevelsAsArrays[charID] < minlevel:
		main.aiLevelsAsArrays[charID] = maxlevel;
	_update_ai_counter();
	
func _set_min() -> void:
	main.aiLevelsAsArrays[charID] = minlevel;
	_update_ai_counter();
	
func _set_random() -> void:
	main.aiLevelsAsArrays[charID] = randi_range(minlevel,maxlevel);
	_update_ai_counter();
	
func _set_max() -> void:
	main.aiLevelsAsArrays[charID] = maxlevel;
	_update_ai_counter();
	
func _update_ai_counter() -> void:
	if main.aiLevelsAsArrays[charID] > minlevel:
		modulate.a = 1;
		get_node("AiLevel/Counter").text = str(main.aiLevelsAsArrays[charID]).pad_zeros(2);
	else:
		modulate.a = 0.2;
		get_node("AiLevel/Counter").text = "X";
		
	if main.aiLevelsAsArrays[charID] == maxlevel:
		modulate.r = 1;
		modulate.g = 0;
		modulate.b = 0;
	else:
		modulate.r = 1;
		modulate.g = 1;
		modulate.b = 1;

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
