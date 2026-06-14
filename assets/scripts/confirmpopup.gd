extends Control

signal confirmaction;

#functions
func _on_button_pressed() -> void: # cancel
	hide();

func _on_button_2_pressed() -> void: # confirm
	confirmaction.emit();
	hide();