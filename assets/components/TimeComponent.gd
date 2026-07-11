class_name TimeComponent extends Component

signal trigger_event;

#variables
@export var loading: Control = null;
@export var clock_timer: Timer = null;
@export var clock_counter: Label = null;
@export var clock_outputs: Array[String] = [];
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

var clock_iteration: int = 0;

@export var player_component: Player_Component = null;

#functions
func _ready() -> void:
	if main.nightcounter == main.ENDLESSID:
		clock_counter.hide();
		player_component._update_endless_mode_output();
	else:
		DiscordManager._update_state(clock_outputs[clock_iteration]);
	if main.save_data_file.slower_nights:
		clock_timer.wait_time = 60;
		clock_timer.start();
	clock_timer.connect("timeout", _clock_timer_timeout);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SKIPNIGHT") && main.nightcounter != main.ENDLESSID:
		if main.CANSKIPNIGHTS:
			_win();

func _clock_timer_timeout() -> void:
	if main.nightcounter != main.ENDLESSID:
		clock_iteration += 1;
		if clock_iteration < clock_outputs.size() - 1:
			_increase_ai_aggressiveness();
			clock_counter.text = clock_outputs[clock_iteration];
			DiscordManager._update_state(clock_outputs[clock_iteration]);
			clock_timer.start();
			trigger_event.emit();
		elif clock_iteration >= clock_outputs.size() - 1:
			_win();
	else:
		player_component._add_hours_endless_mode(1);
		player_component._add_points_endless_mode(1000);
		_increase_ai_aggressiveness();
		clock_timer.start();
		trigger_event.emit();

func _increase_ai_aggressiveness() -> void:
	if main.nightcounter >= 1 && main.nightcounter <= 6 || main.nightcounter == main.ENDLESSID:
		for i in range(main._get_ai_level_as_array().size()):
			if main.ai_levels[main._get_ai_level_as_array()[i]] > 0:
				rng.randomize();
				if rng.randf() <= 0.5:
					main.ai_levels[main._get_ai_level_as_array()[i]] += 1;
				else:
					main.ai_levels[main._get_ai_level_as_array()[i]] += 2;
				if main.ai_levels[main._get_ai_level_as_array()[i]] > main.AIMAXVALUE:
					main.ai_levels[main._get_ai_level_as_array()[i]] = main.AIMAXVALUE;
		print(main.ai_levels);

func _win() -> void:
	get_tree().paused = true;
	loading._load_scene("res://assets/scenes/win_screen.tscn");