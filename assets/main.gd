extends Node

#variables
const DEFAULT_WINDOW_MODE: int = 0;
const DEFAULT_RESOLUTION: int = 1;
const DEFAULT_VSYNC: bool = true;
const DEFAULT_FPSCAP: int = 1;

const DEFAULT_MASTER_VOLUME: float = 1;
const DEFAULT_MUSIC_VOLUME: float = 1;
const DEFAULT_SOUNDS_VOLUME: float = 1;
const DEFAULT_JUMPSCARE_VOLUME: float = 1;

const DEFAULT_FPSCOUNTER: bool = false;

const SAVE_DATA_PATH: String = "user://FNaS4DLC.save";
const SAVE_DATA_PASSWORD: String = "2<0r2eX1&2:<Cd";

var fpsTarget: float = 60.0;
var nightcounter: int = 1;
var isloadingsom: bool = false;
var didrarescreenhappened: bool = false;

#data to save/load
var introscenewatched: bool = false;
var night_to_play: int = 1; # campaign only
var night5ending: bool = false;
var night6ending: bool = false;
var night7ending: bool = false;

var windowmode: int = 0;
var resolution: int = 1;
var vsync: bool = true;
var fpscap: int = 1;

var master_volume: float = 1;
var music_volume: float = 1;
var sounds_volume: float = 1;
var jumpscares_volume: float = 1;

var fps_counter: bool = false;

var cn_challenge_1: bool = false;
var cn_challenge_2: bool = false;
var cn_challenge_3: bool = false;
var cn_challenge_4: bool = false;
var cn_challenge_5: bool = false;
var cn_challenge_6: bool = false;
var cn_challenge_7: bool = false;
var cn_challenge_8: bool = false;
var cn_challenge_9: bool = false;
var cn_challenge_10: bool = false;
var cn_challenge_11: bool = false;
var cn_challenge_12: bool = false;

#player status
var killedBy: String = "";

#character data
const AIMINVALUE: int = 0;
const AIMAXVALUE: int = 25;
const AIDEFAULTLEVEL: int = 5;

var COUNTEREXPOSURELEVELDEFAULT: int = 25;
var COUNTEREXPOSUREDEFAULT: float = 800;

var JUMPSCAREEXPOSURELEVELDEFAULT: int = 12;
var JUMPSCAREEXPOSUREDEFAULT: float = 2500;

var ntsDeskRunning: bool = false;
var ntmDeskWalking: bool = false;
var ncDeskWalking: bool = false;
var isBTInOffice: bool = false;
var nlnDeskWalking: bool = false;

var ai_levels: Dictionary = {
	"Nightmare Toy Sonic": AIDEFAULTLEVEL,
	"Nightmare Toy Mario": AIDEFAULTLEVEL,
	"Nightmare Toy Yoshi": AIDEFAULTLEVEL,
	"Nightmare Taingle": AIDEFAULTLEVEL,
	"Nightmare BT": AIDEFAULTLEVEL,
	"Nightmare S. Sonic": AIDEFAULTLEVEL,
	"Nightmare Cream": AIDEFAULTLEVEL,
	"Nightmare Luiginette": AIMINVALUE,
	"Tails Doll": AIDEFAULTLEVEL,
	"Nightmare Knuckles": AIDEFAULTLEVEL,
};

#functions
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
	
	AudioServer.set_bus_volume_linear(0, master_volume);
	AudioServer.set_bus_volume_linear(1, music_volume);
	AudioServer.set_bus_volume_linear(2, sounds_volume);
	AudioServer.set_bus_volume_linear(3, jumpscares_volume);
	
	match (fps_counter):
		false:
			FpsCounter.get_node("MarginContainer").visible = false;
		true:
			FpsCounter.get_node("MarginContainer").visible = true;

func _ready() -> void:
	_load_game();
	_apply_settings();

func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;

func _get_ai_level_as_array() -> Array[String]:
	return ["Nightmare Toy Sonic", "Nightmare Toy Mario",
	"Nightmare Toy Yoshi", "Nightmare Taingle", "Nightmare BT", "Nightmare S. Sonic",
	"Nightmare Cream", "Nightmare Luiginette", "Tails Doll",
	"Nightmare Knuckles"];

func _reset_ai() -> void:
	for i in range(_get_ai_level_as_array().size()):
		if i != 7:
			ai_levels[_get_ai_level_as_array()[i]] = AIDEFAULTLEVEL;
		else:
			ai_levels[_get_ai_level_as_array()[i]] = AIMINVALUE; # this is for luiginette
	print(ai_levels);
	 
func _save() -> Dictionary:
	var saveDict: Dictionary = {
		"NIGHT5ENDING": night5ending,
		"NIGHT6ENDING": night6ending,
		"NIGHT7ENDING": night7ending,
		"INTROCUTSEEN": introscenewatched,
		"NIGHT2PLAY": night_to_play,
		"WINDOWMODE": windowmode,
		"RESOLUTION": resolution,
		"VSYNC": vsync,
		"FPSCAP": fpscap,
		"MASTERVOLUME": master_volume,
		"MUSICVOLUME": music_volume,
		"SOUNDSVOLUME": sounds_volume,
		"JUMPSCAREVOLUME": jumpscares_volume,
		"FPSCOUNTER": fps_counter,
		"CN1": cn_challenge_1,
		"CN2": cn_challenge_2,
		"CN3": cn_challenge_3,
		"CN4": cn_challenge_4,
		"CN5": cn_challenge_5,
		"CN6": cn_challenge_6,
		"CN7": cn_challenge_7,
		"CN8": cn_challenge_8,
		"CN9": cn_challenge_9,
		"CN10": cn_challenge_10,
		"CN11": cn_challenge_11,
		"CN12": cn_challenge_12,
	};
	return saveDict;

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
			
			night5ending = data["NIGHT5ENDING"];
			night6ending = data["NIGHT6ENDING"];
			night7ending = data["NIGHT7ENDING"];
			introscenewatched = data["INTROCUTSEEN"];
			night_to_play = data["NIGHT2PLAY"];
			
			windowmode = data["WINDOWMODE"];
			resolution = data["RESOLUTION"];
			vsync = data["VSYNC"];
			fpscap = data["FPSCAP"];
			
			master_volume = data["MASTERVOLUME"];
			music_volume = data["MUSICVOLUME"];
			sounds_volume = data["SOUNDSVOLUME"];
			jumpscares_volume = data["JUMPSCAREVOLUME"];
			
			fps_counter = data["FPSCOUNTER"];
			
			cn_challenge_1 = data["CN1"];
			cn_challenge_2 = data["CN2"];
			cn_challenge_3 = data["CN3"];
			cn_challenge_4 = data["CN4"];
			cn_challenge_5 = data["CN5"];
			cn_challenge_6 = data["CN6"];
			cn_challenge_7 = data["CN7"];
			cn_challenge_8 = data["CN8"];
			cn_challenge_9 = data["CN9"];
			cn_challenge_10 = data["CN10"];
			cn_challenge_11 = data["CN11"];
			cn_challenge_12 = data["CN12"];
			
			print(data);