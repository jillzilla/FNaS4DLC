extends Control

signal confirmaction;

#cancel
func _on_button_pressed() -> void:
	self.hide();

#confirm
func _on_button_2_pressed() -> void:
	confirmaction.emit();
	self.hide();
