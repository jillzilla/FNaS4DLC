extends Control

#variables
@onready var guidebutton: Button = $ThingsContainer/Guide;

@onready var confirm: Control = $ConfirmPopUp;
@onready var settings: Control = $Settings;
@onready var guide: Control = $Guide;
@onready var loading: Control = $Loading;

var reload : bool = false;
var quit : bool = false;

#functions
func _ready() -> void:
	get_tree().paused = false;
	self.hide();
	if main.night_to_play > 1:
		guidebutton.visible = true;
	confirm.connect("confirmaction", _confirmed_action);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PAUSE") && ! self.visible && main.PlayerAlive && !main.isloadingsom:
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
	if reload:
		loading._load_scene("res://assets/scenes/night_screen.tscn");
	elif quit:
		loading._load_scene("res://assets/scenes/title.tscn");

func _on_guide_pressed() -> void:
	guide.show();