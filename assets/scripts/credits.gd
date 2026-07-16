extends Control

#variables
@onready var scrollContainer: ScrollContainer = $MarginContainer/Panel/MarginContainer/ScrollContainer;

#functions
func _on_back_button_pressed() -> void:
    hide();
    scrollContainer.set_deferred("scroll_vertical", 0);