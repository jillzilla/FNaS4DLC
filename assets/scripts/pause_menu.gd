extends Control

@export var confirm : Control;
@export var settings : Control;

var reload = false;
var quit = false;

func _ready() -> void:
	get_tree().paused = false;
	self.hide();
	
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
	main._reset_ai();
	
	if reload:
		get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");
	elif quit:
		get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
