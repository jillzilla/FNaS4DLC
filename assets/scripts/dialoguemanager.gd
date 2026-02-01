extends Control

#functions
func _ready() -> void:
	get_node("DialogueBox").modulate.a = 0;
	get_node("DialogueBox/DialogueText").visible = false;
	get_node("DialogueBox/DialogueText").text = "";
	get_node("DialogueBox/DialogueText").visible_characters = 0;
