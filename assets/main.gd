extends Node

#variables
var fpsTarget : float = 60.0;

#characters ai level
var NightmareTaingleAILevel : int = 20;

#functions
func random_chance(percent: float) -> bool:
	return randf() * 100 < percent;