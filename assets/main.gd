extends Node

#variables
var fpsTarget : float = 60.0;

#player status
var killedBy : String = "";
var PlayerPosition : String = "";
var PlayerAlive : bool = true;
var PlayerNotMoving : bool = true;
var ntsDeskRunning : bool = false;
var ntmDeskWalking : bool = false;

#characters ai level
var NightmareToySonicAILevel : int = 0;
var NightmareToyMarioAILevel : int = 25;
var NightmareToyYoshiAILevel : int = 0;
var NightmareTaingleAILevel : int = 0;

#functions
func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;
