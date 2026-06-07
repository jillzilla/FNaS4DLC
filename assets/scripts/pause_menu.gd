extends Control

@onready var loading : Control = $Loading;

@export var guidebutton : Button;

@export var confirm : Control;
@export var settings : Control;
@export var guide : Control;

var reload = false;
var quit = false;

func _ready() -> void:
	get_tree().paused = false;
	self.hide();
	
	if main.night_to_play > 1:
		guidebutton.visible = true;
	
	confirm.connect("confirmaction", _confirmed_action);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PAUSE") && !self.visible && main.PlayerAlive:
		get_tree().paused = true;
		self.show();

func _on_resume_pressed() -> void:
	self.hide();
	get_tree().paused = false;

func _on_restart_pressed() -> void:
	confirm.show();
	reload = true;
	quit = false;
	
func _on_settings_pressed() -> void:
	settings.show();

func _on_quit_pressed() -> void:
	confirm.show();
	reload = false;
	quit = true;

func _confirmed_action() -> void:
	get_tree().paused = false;
	GlobalAudioManager.get_node("Ambience").stop();
	
	if reload:
		loading._load_scene("res://assets/scenes/night_screen.tscn");
		await loading.scene_loaded;
		get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

	elif quit:
		main._reset_ai();
		loading._load_scene("res://assets/scenes/title.tscn");
		await loading.scene_loaded;
		get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_guide_pressed() -> void:
	guide.show();
