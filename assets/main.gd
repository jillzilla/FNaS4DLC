extends Node

#variables
var fpsTarget : float = 60.0;

#player status
var killedBy : String = "";
var PlayerPosition : String = "";
var PlayerAlive : bool = true;
var PlayerNotMoving : bool = true;
var ntsDeskRunning : bool = false;

#characters ai level
var NightmareToySonicAILevel : int = 25;
var NightmareToyYoshiAILevel : int = 25;
var NightmareTaingleAILevel : int = 25;

#functions
func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;
