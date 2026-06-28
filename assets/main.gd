extends Node

@warning_ignore("UNUSED_SIGNAL")
signal update_skin;

#variables
const CANSKIPNIGHTS: bool = true;

const SAVE_DATA_PATH: String = "user://FNaS4DLC.save";
const SAVE_DATA_PASSWORD: String = "2<0r2eX1&2:<Cd";

const DEFAULT_INTROSCENEWATCHED: bool = false;
const DEFAULT_NIGHT2PLAY: int = 1;
const DEFAULT_GUIDE_UNLOCKED: bool = false

const DEFAULT_WINDOW_MODE: int = 0;
const DEFAULT_RESOLUTION: int = 1;
const DEFAULT_VSYNC: bool = true;
const DEFAULT_FPSCAP: int = 1;

const DEFAULT_FLASHLIGHTHOTKEY: Key = KEY_CTRL;
const DEFAULT_MASKHOTKEY: Key = KEY_SHIFT;
const DEFAULT_PAUSEHOTKEY: Key = KEY_ESCAPE;

const DEFAULT_MASTER_VOLUME: float = 1;
const DEFAULT_MUSIC_VOLUME: float = 1;
const DEFAULT_SOUNDS_VOLUME: float = 1;
const DEFAULT_JUMPSCARE_VOLUME: float = 1;

const DEFAULT_FPSCOUNTER: bool = false;

const DEFAULT_NIGHT5ENDING: bool = false;
const DEFAULT_NIGHT6ENDING: bool = false;
const DEFAULT_NIGHT7ENDING: bool = false;

const DEFAULT_TOYTAILS_UNLOCKED: bool = false;
const DEFAULT_LUIGINETTE_BETA_UNLOCKED: bool = false;

const DEFAULT_TAINGLE_SKIN: String = "";
const DEFAULT_LUIGINETTE_SKIN: String = "";

#data to save/load
var introscenewatched: bool = DEFAULT_INTROSCENEWATCHED;
var night_to_play: int = DEFAULT_NIGHT2PLAY; # campaign only
var guideunlocked: bool = DEFAULT_GUIDE_UNLOCKED;

var windowmode: int = DEFAULT_WINDOW_MODE;
var resolution: int = DEFAULT_RESOLUTION;
var vsync: bool = DEFAULT_VSYNC;
var fpscap: int = DEFAULT_FPSCAP;

var keys: Dictionary = {
	"FLASHLIGHT": DEFAULT_FLASHLIGHTHOTKEY,
	"MASK": DEFAULT_MASKHOTKEY,
	"PAUSE": DEFAULT_PAUSEHOTKEY
};

var master_volume: float = DEFAULT_MASTER_VOLUME;
var music_volume: float = DEFAULT_MUSIC_VOLUME;
var sounds_volume: float = DEFAULT_SOUNDS_VOLUME;
var jumpscares_volume: float = DEFAULT_JUMPSCARE_VOLUME;

var fps_counter: bool = DEFAULT_FPSCOUNTER;

var night5ending: bool = DEFAULT_NIGHT5ENDING;
var night6ending: bool = DEFAULT_NIGHT6ENDING;
var night7ending: bool = DEFAULT_NIGHT7ENDING;

var unlocked_skins: Dictionary = {
	"Nightmare Taingle": {
		"Nightmare Toy Tails": DEFAULT_TOYTAILS_UNLOCKED,
	},
	"Nightmare Luiginette": {
		"Beta Luiginette": DEFAULT_LUIGINETTE_BETA_UNLOCKED,
	}
}
var selected_skins: Dictionary = {
	"Nightmare Taingle": DEFAULT_TAINGLE_SKIN,
	"Nightmare Luiginette": DEFAULT_LUIGINETTE_SKIN,
};

#character data stuff
const AIMINVALUE: int = 0;
const AIMAXVALUE: int = 25;
const AIDEFAULTLEVEL: int = 5;

var ai_levels: Dictionary = {
	"Nightmare Toy Sonic": AIDEFAULTLEVEL,
	"Nightmare Toy Mario": AIDEFAULTLEVEL,
	"Nightmare Toy Yoshi": AIDEFAULTLEVEL,
	"Nightmare Taingle": AIDEFAULTLEVEL,
	"Nightmare BT": AIDEFAULTLEVEL,
	"Nightmare S. Sonic": AIDEFAULTLEVEL,
	"Nightmare Cream": AIDEFAULTLEVEL,
	"Nightmare Knuckles": AIDEFAULTLEVEL,
	"Tails Doll": AIDEFAULTLEVEL,
	"Nightmare Luiginette": AIDEFAULTLEVEL,
};

#others
var killedBy: String = "";
var nightcounter: int = 1;
var isloadingsom: bool = false;
var didrarescreenhappened: bool = false;

#functions
func _ready() -> void:
	_load_game();
	_apply_settings();

func _save_game() -> void:
	var SaveGame := FileAccess.open_encrypted_with_pass(SAVE_DATA_PATH, FileAccess.WRITE, SAVE_DATA_PASSWORD);
	var jsonString = JSON.stringify(_save());
	SaveGame.store_line(jsonString);

func _load_game() -> void:
	if !FileAccess.file_exists(SAVE_DATA_PATH):
		_save_game();
		return ;
	else:
		var SaveGame := FileAccess.open_encrypted_with_pass(SAVE_DATA_PATH, FileAccess.READ, SAVE_DATA_PASSWORD);
		
		while SaveGame.get_position() < SaveGame.get_length():
			var JSONString := SaveGame.get_line();
			var json := JSON.new();
			
			@warning_ignore("unused_variable")
			var parseResult := json.parse(JSONString);
			var data = json.get_data();
			
			introscenewatched = data["INTROCUTSEEN"];
			night_to_play = data["NIGHT2PLAY"];
			guideunlocked = data["GUIDEUNLOCKED"];
			
			windowmode = data["WINDOWMODE"];
			resolution = data["RESOLUTION"];
			vsync = data["VSYNC"];
			fpscap = data["FPSCAP"];
			
			keys = data["INPUT"];
			
			master_volume = data["MASTERVOLUME"];
			music_volume = data["MUSICVOLUME"];
			sounds_volume = data["SOUNDSVOLUME"];
			jumpscares_volume = data["JUMPSCAREVOLUME"];
			
			fps_counter = data["FPSCOUNTER"];

			night5ending = data["NIGHT5ENDING"];
			night6ending = data["NIGHT6ENDING"];
			night7ending = data["NIGHT7ENDING"];

			unlocked_skins = data["UNLOCKEDSKINS"];
			selected_skins = data["SELECTEDSKINS"];

			print(data);

func _save() -> Dictionary:
	var saveDict: Dictionary = {
		"INTROCUTSEEN": introscenewatched,
		"NIGHT2PLAY": night_to_play,
		"GUIDEUNLOCKED": guideunlocked,
		"WINDOWMODE": windowmode,
		"RESOLUTION": resolution,
		"VSYNC": vsync,
		"FPSCAP": fpscap,
		"INPUT": keys,
		"MASTERVOLUME": master_volume,
		"MUSICVOLUME": music_volume,
		"SOUNDSVOLUME": sounds_volume,
		"JUMPSCAREVOLUME": jumpscares_volume,
		"FPSCOUNTER": fps_counter,
		"NIGHT5ENDING": night5ending,
		"NIGHT6ENDING": night6ending,
		"NIGHT7ENDING": night7ending,
		"UNLOCKEDSKINS": unlocked_skins,
		"SELECTEDSKINS": selected_skins,
	};
	return saveDict;

func _apply_settings() -> void:
	match (windowmode):
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
		
	match (resolution):
		0:
			DisplayServer.window_set_size(Vector2(640, 360), 0);
		1:
			DisplayServer.window_set_size(Vector2(1280, 720), 0);
		2:
			DisplayServer.window_set_size(Vector2(1920, 1080), 0);
	
	@warning_ignore("integer_division")
	var center_screen: Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2;
	var window_size: Vector2i = get_window().get_size_with_decorations()
	@warning_ignore("integer_division")
	var new_window_position: Vector2i = center_screen - window_size / 2;
	get_window().set_position(new_window_position);
	
	match (vsync):
		false:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED);
		true:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED);
			
	match (fpscap):
		0:
			Engine.max_fps = 30;
		1:
			Engine.max_fps = 60;
		2:
			Engine.max_fps = 120;
		3:
			Engine.max_fps = 0;

	var mask_input_key: InputEvent = InputEventKey.new();
	var flash_input_key: InputEvent = InputEventKey.new();
	var pause_input_key: InputEvent = InputEventKey.new();

	flash_input_key.keycode = keys["FLASHLIGHT"];
	mask_input_key.keycode = keys["MASK"];
	pause_input_key.keycode = keys["PAUSE"];

	InputMap.action_erase_events("FLASHLIGHT");
	InputMap.action_add_event("FLASHLIGHT", flash_input_key);

	InputMap.action_erase_events("MASK");
	InputMap.action_add_event("MASK", mask_input_key);

	InputMap.action_erase_events("PAUSE");
	InputMap.action_add_event("PAUSE", pause_input_key);
	
	AudioServer.set_bus_volume_linear(0, master_volume);
	AudioServer.set_bus_volume_linear(1, music_volume);
	AudioServer.set_bus_volume_linear(2, sounds_volume);
	AudioServer.set_bus_volume_linear(3, jumpscares_volume);
	
	match (fps_counter):
		false:
			FpsCounter.get_node("MarginContainer").hide();
		true:
			FpsCounter.get_node("MarginContainer").show();

func _reset_ai() -> void:
	for i in range(_get_ai_level_as_array().size()):
		ai_levels[_get_ai_level_as_array()[i]] = AIDEFAULTLEVEL;
	print(ai_levels);

func _get_ai_level_as_array() -> Array[String]:
	return ["Nightmare Toy Sonic", "Nightmare Toy Mario",
	"Nightmare Toy Yoshi", "Nightmare Taingle", "Nightmare BT", "Nightmare S. Sonic",
	"Nightmare Cream", "Nightmare Knuckles", "Tails Doll",
	"Nightmare Luiginette"];