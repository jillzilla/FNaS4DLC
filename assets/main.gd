extends Node

#variables
var fpsTarget : float = 60.0;
var isOnDialogue : bool = false;

var nightcounter : int = 1;

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
var isBTInOffice : bool = false;

#characters ai level
const aiDefaultLevel : int = 5;

var NightmareToySonicAILevel : int = aiDefaultLevel;
var NightmareToyMarioAILevel : int = aiDefaultLevel;
var NightmareToyYoshiAILevel : int = aiDefaultLevel;
var NightmareTaingleAILevel : int = aiDefaultLevel;
var NightmareBTAILevel : int = aiDefaultLevel;

var aiLevelsAsArrays : Array[int] = [NightmareToySonicAILevel,NightmareToyMarioAILevel,NightmareToyYoshiAILevel,NightmareTaingleAILevel,NightmareBTAILevel];

#functions
func _update_ai_levels() -> void:
	NightmareToySonicAILevel = aiLevelsAsArrays[0];
	NightmareToyMarioAILevel = aiLevelsAsArrays[1];
	NightmareToyYoshiAILevel = aiLevelsAsArrays[2];
	NightmareTaingleAILevel = aiLevelsAsArrays[3];
	NightmareBTAILevel = aiLevelsAsArrays[4];
	
func _reset_ai() -> void:
	for i in range(aiLevelsAsArrays.size()):
		aiLevelsAsArrays[i] = aiDefaultLevel;
	_update_ai_levels();

func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;
