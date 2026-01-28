extends Node

#variables
var fpsTarget : float = 60.0;

#player status
var killedBy : String = "";
var PlayerPosition : String = "";
var PlayerAlive : bool = true;
var PlayerNotMoving : bool = true;

#characters ai level
var NightmareToySonicAILevel : int = 20;
var NightmareToyYoshiAILevel : int = 20;
var NightmareTaingleAILevel : int = 20;

#functions
func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;
