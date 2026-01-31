extends Node

#variables
var fpsTarget : float = 60.0;

#player status
var killedBy : String = "";
var PlayerPosition : String = "";
var PlayerAlive : bool = true;
var PlayerNotMoving : bool = true;

#characters stuff
var ntsDeskRunning : bool = false;
var ntmDeskWalking : bool = false;

#characters ai level
var NightmareToySonicAILevel : int = 0;
var NightmareToyMarioAILevel : int = 0;
var NightmareToyYoshiAILevel : int = 0;
var NightmareTaingleAILevel : int = 0;
var NightmareBTAILevel : int = 0;

var aiLevelsAsArrays : Array[int] = [NightmareToySonicAILevel,NightmareToyMarioAILevel,NightmareToyYoshiAILevel,NightmareTaingleAILevel,NightmareBTAILevel];

#functions
func _update_ai_levels() -> void:
	NightmareToySonicAILevel = aiLevelsAsArrays[0];
	NightmareToyMarioAILevel = aiLevelsAsArrays[1];
	NightmareToyYoshiAILevel = aiLevelsAsArrays[2];
	NightmareTaingleAILevel = aiLevelsAsArrays[3];
	NightmareBTAILevel = aiLevelsAsArrays[4];

func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;
