extends VBoxContainer

#variables
@export var charName : String;
@export var iconPath : String;
@export_range(0,9) var charID : int = 0;

const minlevel : int = 0;
const maxlevel : int = 25;

var canAddFocus : bool = false;
var canSubFocus : bool = false;

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

func _process(_delta: float) -> void:
	if !canAddFocus && !canSubFocus:
		if !get_node("Timer_Change").is_stopped():
			get_node("Timer_Change").stop();
		return;
	
	elif canAddFocus:
		if get_node("Timer_Change").is_stopped():
			_add();
			get_node("Timer_Change").start();
		await get_node("Timer_Change").timeout;
		
	elif canSubFocus:
		if get_node("Timer_Change").is_stopped():
			_sub();
			get_node("Timer_Change").start();
		await get_node("Timer_Change").timeout;
		
func _on_left_button_down() -> void:
	if get_node("Timer_Focus").is_stopped():
		_sub();
		get_node("Timer_Focus").start();
		await get_node("Timer_Focus").timeout;
		canSubFocus = true;
		canAddFocus = false;

func _on_right_button_down() -> void:
	if get_node("Timer_Focus").is_stopped():
		_add();
		get_node("Timer_Focus").start();
		await get_node("Timer_Focus").timeout;
		canAddFocus = true;
		canSubFocus = false;
	
func _on_left_button_up() -> void:
	canAddFocus = false;
	canSubFocus = false;
	if !get_node("Timer_Focus").is_stopped():
		get_node("Timer_Focus").stop();
	get_node("Timer_Change").stop();
	
func _on_left_mouse_exited() -> void:
	canAddFocus = false;
	canSubFocus = false;
	if !get_node("Timer_Focus").is_stopped():
		get_node("Timer_Focus").stop();
	get_node("Timer_Change").stop();

func _on_right_button_up() -> void:
	canAddFocus = false;
	canSubFocus = false;
	if !get_node("Timer_Focus").is_stopped():
		get_node("Timer_Focus").stop();
	get_node("Timer_Change").stop();

func _on_right_mouse_exited() -> void:
	canAddFocus = false;
	canSubFocus = false;
	if !get_node("Timer_Focus").is_stopped():
		get_node("Timer_Focus").stop();
	get_node("Timer_Change").stop();
	
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
