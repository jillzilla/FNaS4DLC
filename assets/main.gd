extends Node

#variables
const saveDataPath : String = "user://FNaS4DLC.save";
const saveDataPassword : String = "2<0r2eX1&2:<Cd";

var fpsTarget : float = 60.0;

var nightcounter : int = 0;

#data to save/load
var introscenewatched : bool = false;
var night_to_play : int = 1; #campaign only
var night5ending : bool = false;
var night6ending : bool = false;
var night7ending : bool = false;

#player status
var killedBy : String = "";
var PlayerPosition : String = "";

var PlayerAlive : bool = true;
var PlayerNotMoving : bool = true;

#characters stuff
var ntsDeskRunning : bool = false;
var ntmDeskWalking : bool = false;
var ncDeskWalking : bool = false;
var isBTInOffice : bool = false;
var nlnDeskWalking : bool = false;

#characters ai level
const aiDefaultLevel : int = 5;

var NightmareToySonicAILevel : int = aiDefaultLevel;
var NightmareToyMarioAILevel : int = aiDefaultLevel;
var NightmareToyYoshiAILevel : int = aiDefaultLevel;
var NightmareTaingleAILevel : int = aiDefaultLevel;
var NightmareBTAILevel : int = aiDefaultLevel;
var NightmareSalvageAiLevel : int = aiDefaultLevel;
var NightmareCreamAiLevel : int = aiDefaultLevel;
var NightmareLuiginetteAiLevel : int = aiDefaultLevel;

var aiLevelsAsArrays : Array[int] = [NightmareToySonicAILevel,NightmareToyMarioAILevel,NightmareToyYoshiAILevel,NightmareTaingleAILevel,NightmareBTAILevel,NightmareSalvageAiLevel,NightmareCreamAiLevel,NightmareLuiginetteAiLevel];

#functions
func _ready() -> void:
	_load_game();

func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;

func _update_ai_levels() -> void:
	NightmareToySonicAILevel = aiLevelsAsArrays[0];
	NightmareToyMarioAILevel = aiLevelsAsArrays[1];
	NightmareToyYoshiAILevel = aiLevelsAsArrays[2];
	NightmareTaingleAILevel = aiLevelsAsArrays[3];
	NightmareBTAILevel = aiLevelsAsArrays[4];
	NightmareSalvageAiLevel = aiLevelsAsArrays[5];
	NightmareCreamAiLevel = aiLevelsAsArrays[6];
	NightmareLuiginetteAiLevel = aiLevelsAsArrays[7];
	
func _reset_ai() -> void:
	for i in range(aiLevelsAsArrays.size()):
		aiLevelsAsArrays[i] = aiDefaultLevel;
	_update_ai_levels();
	
func _save() -> Dictionary:
	var saveDict : Dictionary = {
		"NIGHT5ENDING" : night5ending,
		"NIGHT6ENDING" : night6ending,
		"NIGHT7ENDING" : night7ending,
		"INTROCUTSEEN" : introscenewatched,
		"NIGHT2PLAY" : night_to_play,
	};
	return saveDict;

func _save_game() -> void:
	var SaveGame := FileAccess.open_encrypted_with_pass(saveDataPath,FileAccess.WRITE,saveDataPassword);
	var jsonString = JSON.stringify(_save());
	SaveGame.store_line(jsonString);

func _load_game() -> void:
	if !FileAccess.file_exists(saveDataPath):
		_save_game();
		return;
	else:
		var SaveGame := FileAccess.open_encrypted_with_pass(saveDataPath,FileAccess.READ,saveDataPassword);
		
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
			
			print(data);
