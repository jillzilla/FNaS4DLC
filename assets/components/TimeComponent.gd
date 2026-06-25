class_name TimeComponent extends Component

signal trigger_event;

#variables
@export var loading: Control;
@export var clock_timer: Timer;
@export var clock_counter: Label;
@export var clock_outputs: Array[String];
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

var clock_iteration: int = 0;

#functions
func _ready() -> void:
	DiscordManager._update_state(clock_outputs[clock_iteration]);
	clock_timer.connect("timeout", _clock_timer_timeout);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SKIPNIGHT"):
		if main.CANSKIPNIGHTS:
			_win();

func _clock_timer_timeout() -> void:
	clock_iteration += 1;
	if clock_iteration < clock_outputs.size() - 1:
		_increase_ai_aggressiveness();
		clock_counter.text = clock_outputs[clock_iteration];
		DiscordManager._update_state(clock_outputs[clock_iteration]);
		clock_timer.start();
		trigger_event.emit();
	elif clock_iteration >= clock_outputs.size() - 1:
		_win();

func _increase_ai_aggressiveness() -> void:
	if main.nightcounter > 0 && main.nightcounter < 7:
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